# Feeds in, one EPUB out.
#
# This replaces the old `custom.hm.rss` module (newsboat + NewsFlash). The
# reasoning: both remaining feeds are long-form essay blogs that publish a few
# times a week and ship their full text in the feed. That is a batch job, not
# a queue to check. Calibre assembles the week into a book, foliate reads it
# offline with the dictd dictionaries, and there is no reader to keep up with.
{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.custom.hm.news;

  # Feed titles land inside a Python source file, and at least one of them has
  # an apostrophe in it. Quote and escape rather than hope.
  pyStr = s: "'" + lib.replaceStrings [ "\\" "'" ] [ "\\\\" "\\'" ] s + "'";

  feedLines = lib.concatMapStrings (f: "        (${pyStr f.title}, ${pyStr f.url}),\n") cfg.feeds;

  # A recipe is a Python class. calibre reads the feed only to get the article
  # list; what it does next depends on useEmbeddedContent below.
  recipe = pkgs.writeText "${cfg.slug}.recipe" ''
    from calibre.web.feeds.news import BasicNewsRecipe


    class Issue(BasicNewsRecipe):
        title = ${pyStr cfg.title}
        description = ${pyStr cfg.description}
        language = 'en'
        oldest_article = ${toString cfg.oldestArticle}
        max_articles_per_feed = ${toString cfg.maxArticles}
        use_embedded_content = ${if cfg.useEmbeddedContent then "True" else "False"}
        auto_cleanup = ${if cfg.useEmbeddedContent then "False" else "True"}
        no_stylesheets = True
        remove_javascript = True

        feeds = [
    ${feedLines}    ]
  '';

  build = pkgs.writeShellApplication {
    name = "build-news-issue";
    runtimeInputs = [
      pkgs.calibre
      pkgs.coreutils
    ];
    text = ''
      out=${lib.escapeShellArg cfg.outputDir}
      mkdir -p "$out"

      # Build into a temp dir and move the finished file into place. A library
      # scanner that walks the output folder must never find a half-written
      # EPUB and index it as a broken book.
      tmp=$(mktemp -d)
      trap 'rm -rf "$tmp"' EXIT

      # A laptop timer fires whenever the machine happens to be awake, which is
      # often a few seconds before wifi comes up. Retry rather than lose the
      # issue until next week.
      for attempt in 1 2 3; do
        if ebook-convert ${recipe} "$tmp/issue.epub"; then
          mv "$tmp/issue.epub" "$out/${cfg.slug}-$(date +%Y-%m-%d).epub"
          exit 0
        fi
        echo "attempt $attempt failed" >&2
        [ "$attempt" = 3 ] || sleep 60
      done
      exit 1
    '';
  };
in
{
  options.custom.hm.news = {
    enable = lib.mkEnableOption "Enable the calibre news module (feeds to EPUB)";

    title = lib.mkOption {
      type = lib.types.str;
      default = "Reading";
      description = "Periodical title. calibre appends the issue date to it.";
    };

    slug = lib.mkOption {
      type = lib.types.str;
      default = "reading";
      description = "Filename stem for each issue, before the date.";
    };

    description = lib.mkOption {
      type = lib.types.str;
      default = "Long-form blogs, assembled into one issue.";
      description = "Blurb stored in the EPUB metadata.";
    };

    feeds = lib.mkOption {
      type = lib.types.listOf (
        lib.types.submodule {
          options = {
            url = lib.mkOption {
              type = lib.types.str;
              description = "Feed URL.";
            };
            title = lib.mkOption {
              type = lib.types.str;
              description = "Section name in the issue's table of contents.";
            };
            tags = lib.mkOption {
              type = lib.types.listOf lib.types.str;
              default = [ ];
              description = "Newsboat tags. The recipe ignores these.";
            };
          };
        }
      );
      default = [
        {
          url = "https://astralcodexten.substack.com/feed";
          title = "Astral Codex Ten";
          tags = [ "blog" ];
        }
        {
          url = "https://www.thepsmiths.com/feed";
          title = "Mr. and Mrs. Psmith's Bookshelf";
          tags = [ "blog" ];
        }
      ];
      description = "Feeds that make up one issue, and that the reader shows.";
    };

    reader.enable = lib.mkEnableOption ''
      Enable newsboat, reading the same feed list as the recipe. This is the
      thing the old custom.hm.rss module got wrong: the urls, feeds.opml and
      the recipe were three hand-maintained copies of one list. Here the list
      lives in `feeds` above and both consumers derive from it
    '';

    # This is per-recipe, not per-feed, which is the one real limit here. Both
    # feeds above send content:encoded, so `true` is correct and calibre never
    # touches the sites. Add a feed that sends summaries only and you want a
    # second module instance with this set to false, not a mixed list.
    useEmbeddedContent = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Whether the feeds carry full article text. When true, calibre uses the
        feed body and fetches nothing. When false, it downloads each article
        page and runs the readability cleanup over it.
      '';
    };

    oldestArticle = lib.mkOption {
      type = lib.types.int;
      default = 7;
      description = "Ignore articles older than this many days.";
    };

    maxArticles = lib.mkOption {
      type = lib.types.int;
      default = 50;
      description = "Cap on articles taken from each feed.";
    };

    outputDir = lib.mkOption {
      type = lib.types.str;
      default = "${config.home.homeDirectory}/Books/News";
      description = ''
        Where each issue lands. Point a komga library at this to read issues on
        other devices; foliate opens them straight from disk either way.
      '';
    };

    schedule = lib.mkOption {
      type = lib.types.str;
      default = "Sun 06:00";
      description = ''
        systemd OnCalendar expression. The default pairs with oldestArticle = 7
        so that one issue covers exactly one week with no gap and no overlap.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    # Also on PATH, so you can build an issue by hand without waiting a week.
    home.packages = [ build ];

    # The reader is for skimming what landed today. The weekly EPUB is for
    # sitting down with. Same feeds, two speeds.
    programs.newsboat = lib.mkIf cfg.reader.enable {
      enable = true;
      autoReload = true;
      # Low-volume blogs; don't hammer them (minutes).
      reloadTime = 120;
      reloadThreads = 4;
      # home-manager writes this value unquoted, so quote it here or newsboat
      # rejects the config with "too many parameters".
      browser = ''"xdg-open %u"'';

      urls = map (f: { inherit (f) url title tags; }) cfg.feeds;

      extraConfig = ''
        text-width 100
        article-sort-order date-desc

        # Some hosts behind Cloudflare 403 non-browser user agents. Nothing in
        # the list needs this today, but it is the first thing to reach for
        # when a new feed starts 403ing on reload.
        user-agent "Mozilla/5.0 (X11; Linux x86_64; rv:128.0) Gecko/20100101 Firefox/128.0"

        # Named ANSI slots only: newsboat can't take hex, but the terminal
        # palette is themed from config.colorScheme, so these inherit it.
        color listnormal        default default
        color listnormal_unread default default bold
        color listfocus         black   blue
        color listfocus_unread  black   blue    bold
        color info              yellow  black
        color article           default default
      '';
    };

    systemd.user.services.news-issue = {
      Unit.Description = "Build a ${cfg.title} issue from the feed list";
      Service = {
        Type = "oneshot";
        ExecStart = "${build}/bin/build-news-issue";
      };
    };

    systemd.user.timers.news-issue = {
      Unit.Description = "Weekly ${cfg.title} issue";
      Timer = {
        OnCalendar = cfg.schedule;
        # The machine is a laptop and is often asleep at 06:00. Without this a
        # missed firing is a lost week.
        Persistent = true;
        RandomizedDelaySec = "15m";
      };
      Install.WantedBy = [ "timers.target" ];
    };
  };
}
