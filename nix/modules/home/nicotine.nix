# Nicotine+ has one download folder. This sorts what lands in it.
#
# Nicotine+ 3.3 has no per-file-type destination, and its own post-download
# hooks are the wrong tool for the job. `afterfolder` never fires for a plain
# "Download File(s)" pick, because those files land flat in the download root
# and the hook returns early when the finished folder is the root itself. Worse,
# with "Download Folder & Subfolders" a child folder fires while its parent is
# still downloading, so a mover wired to the hook splits the tree.
#
# So nothing here touches Nicotine+ settings. A watcher waits for the download
# folder to go quiet, then a sweep reads the folder and moves each top-level
# entry as one unit. The sweep looks at the filesystem, not at an event stream,
# so a dropped or coalesced inotify event only changes when it runs, never what
# it decides.
{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.custom.hm.nicotine;

  # Destinations and extension sets land inside a Python source file. Quote and
  # escape rather than hope; a path with an apostrophe in it would end the
  # string early.
  pyStr = s: "'" + lib.replaceStrings [ "\\" "'" ] [ "\\\\" "\\'" ] s + "'";
  pySet = xs: if xs == [ ] then "set()" else "{" + lib.concatMapStringsSep ", " pyStr xs + "}";

  categoryLines = lib.concatStrings (
    lib.mapAttrsToList (
      name: c: "    ${pyStr name}: (${pyStr c.destination}, ${pySet c.extensions}),\n"
    ) cfg.categories
  );

  sorter = pkgs.writers.writePython3Bin "nicotine-sort"
    {
      # Long f-strings in the report lines read better than wrapped ones.
      flakeIgnore = [ "E501" ];
    }
    ''
      """Move finished Nicotine+ downloads out of the download folder, by type.

      Usage:
        nicotine-sort [-n] [--quiet-seconds N] [PATH ...]

      With no PATH, sweeps every top-level entry in the download folder. With one
      or more PATH, handles only those. Each PATH is resolved up to its top-level
      entry first, so a caller reporting 'downloads/Album/CD1' moves
      'downloads/Album' whole. A PATH that no longer exists is ignored.

      Each entry moves as one unit: a loose file on its own, a folder intact with
      everything in it. A folder's type is the category that owns the most bytes.
      Weighting by bytes rather than by file count is what keeps a book folder a
      book folder: ~/Books/hwmrust holds 108 MB of PDFs next to 0.3 MB of .ogg
      game assets, and only the byte weighting calls that right.

      An entry is skipped when either guard fires:
        * Nicotine+ still lists a queued or unfinished transfer aimed at it.
        * Anything inside it was written less than --quiet-seconds ago.
      """

      import json
      import os
      import shutil
      import sys
      import time

      QUIET_SECONDS = ${toString cfg.quietSeconds}

      # Category -> (destination, extensions). Generated from custom.hm.nicotine.
      CATEGORIES = {
      ${categoryLines}}

      # These never decide a folder's type. They still travel with it.
      FILLER = ${pySet cfg.filler}

      # Set in Nix to pin the download folder. None means read it from the
      # Nicotine+ config, which can never drift from what the GUI is using.
      DOWNLOAD_DIR = ${if cfg.downloadDir == null then "None" else pyStr cfg.downloadDir}

      EXT_CATEGORY = {ext: name for name, (_, exts) in CATEGORIES.items() for ext in exts}


      def data_folder():
          xdg = os.environ.get("XDG_DATA_HOME") or os.path.join(os.path.expanduser("~"), ".local", "share")
          return os.path.join(xdg.split(":")[0], "nicotine")


      def config_file():
          xdg = os.environ.get("XDG_CONFIG_HOME") or os.path.join(os.path.expanduser("~"), ".config")
          return os.path.join(xdg.split(":")[0], "nicotine", "config")


      def download_root():
          """Read downloaddir out of the Nicotine+ config, the way Nicotine+ does."""
          if DOWNLOAD_DIR:
              return os.path.normpath(os.path.expanduser(DOWNLOAD_DIR))

          os.environ.setdefault("NICOTINE_DATA_HOME", data_folder())
          raw = None
          section = None

          try:
              with open(config_file(), encoding="utf-8") as handle:
                  for line in handle:
                      line = line.strip()
                      if line.startswith("["):
                          section = line.strip("[]")
                      elif section == "transfers" and line.startswith("downloaddir"):
                          raw = line.split("=", 1)[1].strip()
                          break
          except OSError:
              pass

          if not raw:
              raw = os.path.join(data_folder(), "downloads")

          return os.path.normpath(os.path.expandvars(os.path.expanduser(raw)))


      def pending_folders():
          """Folder paths Nicotine+ still has unfinished transfers for.

          Rows are [username, virtual_path, folder_path, status, size, ...].
          write_file_and_backup renames the live file to .old before writing, so
          .old is one generation behind and is only a parse-error fallback.

          This file is saved every 180 s and on quit, so it can lag. The watcher
          debounce is set at or above that interval to cover the gap.
          """
          base = os.path.join(data_folder(), "downloads.json")

          for path in (base, base + ".old"):
              try:
                  with open(path, encoding="utf-8") as handle:
                      rows = json.load(handle)
              except (OSError, ValueError):
                  continue

              found = set()
              for row in rows:
                  if len(row) > 3 and row[2] and row[3] != "Finished":
                      found.add(os.path.normpath(row[2]))
              return found

          return set()


      def newest_mtime(path):
          newest = os.lstat(path).st_mtime
          for folder, _dirs, files in os.walk(path):
              for name in [folder] + [os.path.join(folder, f) for f in files]:
                  try:
                      newest = max(newest, os.lstat(name).st_mtime)
                  except OSError:
                      pass
          return newest


      def classify(path):
          """Return a category name, or None to leave the entry alone."""
          if os.path.isfile(path):
              return EXT_CATEGORY.get(os.path.splitext(path)[1].lstrip(".").lower())

          weights = {}
          for folder, _dirs, files in os.walk(path):
              for name in files:
                  ext = os.path.splitext(name)[1].lstrip(".").lower()
                  if ext in FILLER:
                      continue
                  category = EXT_CATEGORY.get(ext)
                  if not category:
                      continue
                  try:
                      size = os.lstat(os.path.join(folder, name)).st_size
                  except OSError:
                      size = 0
                  weights[category] = weights.get(category, 0) + size

          if not weights:
              return None
          return max(weights, key=weights.get)


      def free_name(dest_folder, basename):
          stem, ext = os.path.splitext(basename)
          candidate = basename
          counter = 2
          while os.path.lexists(os.path.join(dest_folder, candidate)):
              candidate = f"{stem} ({counter}){ext}"
              counter += 1
          return os.path.join(dest_folder, candidate)


      def top_level_entry(path, root):
          """Walk a reported path up to the entry sitting directly under root.

          Returns None when the path is not under root at all. Resolving upward is
          what makes the pending-transfer guard correct: every candidate is a
          direct child of root, so an exact or below match covers every case.
          """
          path = os.path.normpath(os.path.abspath(os.path.expanduser(path)))

          if path == root:
              return None
          if not path.startswith(root + os.sep):
              return None

          relative = path[len(root) + 1:]
          return os.path.join(root, relative.split(os.sep)[0])


      def parse_args(argv, root):
          dry_run = False
          quiet_seconds = QUIET_SECONDS
          targets = []
          got_paths = False
          rest = list(argv)

          while rest:
              item = rest.pop(0)
              if item in ("-n", "--dry-run"):
                  dry_run = True
              elif item == "--quiet-seconds":
                  quiet_seconds = int(rest.pop(0))
              else:
                  got_paths = True
                  entry = top_level_entry(item, root)
                  if entry is None:
                      print(f"ignored (outside download folder) {item}", file=sys.stderr)
                  elif entry not in targets:
                      targets.append(entry)

          return dry_run, quiet_seconds, targets, got_paths


      def main():
          root = download_root()

          if not os.path.isdir(root):
              sys.exit(f"download folder not found: {root}")

          dry_run, quiet_seconds, targets, got_paths = parse_args(sys.argv[1:], root)

          if got_paths and not targets:
              # Every path given was rejected. Do not fall back to a full sweep.
              return

          if not got_paths:
              targets = [os.path.join(root, n) for n in sorted(os.listdir(root)) if not n.startswith(".")]

          pending = pending_folders()
          now = time.time()

          for path in targets:
              name = os.path.basename(path)

              # A caller can report a path an earlier call already moved.
              if not os.path.lexists(path):
                  continue

              if any(p == path or p.startswith(path + os.sep) for p in pending):
                  print(f"skip (queued transfer)   {name}")
                  continue

              age = now - newest_mtime(path)
              if age < quiet_seconds:
                  print(f"skip (active, {int(age)}s old) {name}")
                  continue

              category = classify(path)
              if not category:
                  print(f"skip (unknown type)      {name}")
                  continue

              dest_folder = os.path.expanduser(CATEGORIES[category][0])
              target = free_name(dest_folder, name)

              print(f"{'would move' if dry_run else 'move'} -> {category} {name}")
              if dry_run:
                  continue

              os.makedirs(dest_folder, exist_ok=True)
              try:
                  shutil.move(path, target)
              except OSError as error:
                  print(f"FAILED {name}: {error}", file=sys.stderr)


      if __name__ == "__main__":
          main()
    '';

  watcher = pkgs.writeShellApplication {
    name = "nicotine-sort-watch";
    runtimeInputs = [
      sorter
      pkgs.inotify-tools
    ];
    text = ''
      root=${
        if cfg.downloadDir == null then
          ''"$HOME/.local/share/nicotine/downloads"''
        else
          lib.escapeShellArg cfg.downloadDir
      }

      mkdir -p "$root"

      # Nicotine+ finishes a download with shutil.move out of its incomplete
      # folder, which on one filesystem is a rename. The arriving event is
      # MOVED_TO, never CLOSE_WRITE. A watcher listening only for close_write
      # sees nothing at all.
      #
      # systemd .path units cannot do this job: they are not recursive, so a
      # PathModified= on the download folder fires when Album/ is created, which
      # is the start of a folder download, and stays silent as the files land
      # inside it.
      while :; do
        # Block until something happens. Exit 1 here means an event we did not
        # ask for, such as unmount; sweeping anyway is harmless.
        inotifywait -qq -r -e moved_to -e moved_from -e create -e delete -e close_write "$root" || true

        # Then wait for a full quiet period with no further events. inotifywait
        # exits 2 on timeout, which is the signal that the folder settled.
        while inotifywait -qq -r -t ${toString cfg.debounceSeconds} \
          -e moved_to -e moved_from -e create -e delete -e close_write "$root"; do
          :
        done

        nicotine-sort
      done
    '';
  };
in
{
  options.custom.hm.nicotine = {
    enable = lib.mkEnableOption "Sort finished Nicotine+ downloads into libraries by file type";

    downloadDir = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = ''
        The Nicotine+ download folder. Leave null to read `downloaddir` out of
        the Nicotine+ config at run time, which is preferred: Nicotine+ rewrites
        its own config on exit, so a value set here can drift from what the GUI
        is actually using.
      '';
    };

    categories = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.submodule {
          options = {
            destination = lib.mkOption {
              type = lib.types.str;
              description = "Where entries of this category go.";
            };
            extensions = lib.mkOption {
              type = lib.types.listOf lib.types.str;
              description = "Lowercase extensions, without the dot.";
            };
          };
        }
      );
      default = {
        books = {
          destination = "${config.home.homeDirectory}/Books";
          extensions = [
            "epub"
            "mobi"
            "azw"
            "azw3"
            "pdf"
            "djvu"
            "cbz"
            "cbr"
            "fb2"
            "lit"
            "chm"
          ];
        };
        # One bucket for all audio, sorted onward by hand. Nothing in a file's
        # extension separates an audiobook from an album; only duration does,
        # and that needs a tag reader. So this does not pretend to guess. It
        # gets audio out of the download folder and into one place to triage.
        audio = {
          destination = "${config.home.homeDirectory}/Audio";
          extensions = [
            "mp3"
            "flac"
            "ogg"
            "opus"
            "m4a"
            "m4b"
            "wav"
            "aac"
            "wma"
            "ape"
            "aiff"
          ];
        };
        video = {
          destination = "${config.home.homeDirectory}/Videos";
          extensions = [
            "mkv"
            "mp4"
            "avi"
            "mov"
            "webm"
            "m4v"
            "wmv"
            "flv"
          ];
        };
      };
      description = ''
        Category to destination and extension list. An entry whose extensions
        match no category is left in the download folder, which is deliberate:
        the download folder is the place where undecided things are visible.
      '';
    };

    filler = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [
        "jpg"
        "jpeg"
        "png"
        "gif"
        "bmp"
        "webp"
        "nfo"
        "txt"
        "md"
        "opf"
        "cue"
        "m3u"
        "m3u8"
        "sfv"
        "log"
        "srt"
        "sub"
        "idx"
        "url"
        "db"
        "ini"
        "sig"
        "torrent"
      ];
      description = ''
        Extensions that never vote on a folder's category. They still move with
        the folder. Without this a 200 kB cover.jpg and a .nfo would be counted
        against the actual content.
      '';
    };

    quietSeconds = lib.mkOption {
      type = lib.types.int;
      default = 60;
      description = ''
        A sweep skips an entry written more recently than this. The watcher's
        debounce already waited, so this is a backstop for a hand-run sweep.
        Keep it below debounceSeconds or the watcher will skip what it just
        waited for.
      '';
    };

    debounceSeconds = lib.mkOption {
      type = lib.types.int;
      default = 180;
      description = ''
        The watcher sweeps after this many seconds with no filesystem event.
        Nicotine+ saves its transfer list every 180 s, so a value below that
        lets a sweep run against a stale queue and move a folder that still has
        a track coming.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    # On PATH so you can preview a sweep with `nicotine-sort -n` before trusting
    # the service with it.
    home.packages = [
      sorter
      watcher
    ];

    systemd.user.services.nicotine-sort = {
      Unit.Description = "Sort finished Nicotine+ downloads into libraries";
      Service = {
        ExecStart = "${watcher}/bin/nicotine-sort-watch";
        # inotifywait dies with the watched folder, and Nicotine+ recreates that
        # folder on next launch. Restarting is the whole recovery story.
        Restart = "always";
        RestartSec = 10;
      };
      Install.WantedBy = [ "default.target" ];
    };
  };
}
