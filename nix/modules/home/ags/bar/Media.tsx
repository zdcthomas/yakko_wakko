// The media card: cover art, title and artist, a seek bar with times, and
// back / play-pause / next. It opens from the track in the centre capsule.
import Gtk from "gi://Gtk?version=4.0"
import GLib from "gi://GLib"
import Pango from "gi://Pango"
import AstalMpris from "gi://AstalMpris"
import { createBinding, createState } from "ags"
import { execAsync } from "ags/process"

const ART_DIR = `${GLib.get_user_cache_dir()}/ags-bar/art`

// AstalMpris caches cover art through GIO, which cannot read https:// with
// no gvfs, so its coverArt stays empty. Fetch Spotify's art URL with curl
// into our own cache, one file per URL.
function coverArt(p: AstalMpris.Player) {
  const [file, setFile] = createState("")
  const load = () => {
    const url = p.artUrl
    if (!url) return setFile("")
    if (url.startsWith("file://")) return setFile(url.slice(7))
    const path = `${ART_DIR}/${GLib.compute_checksum_for_string(GLib.ChecksumType.SHA1, url, -1)}`
    if (GLib.file_test(path, GLib.FileTest.EXISTS)) return setFile(path)
    GLib.mkdir_with_parents(ART_DIR, 0o755)
    execAsync(["curl", "-sfLo", path, url])
      .then(() => p.artUrl === url && setFile(path))
      .catch(console.error)
  }
  p.connect("notify::art-url", load)
  load()
  return file
}

const fmt = (sec: number) => {
  const t = Math.max(0, Math.floor(sec))
  return `${Math.floor(t / 60)}:${String(t % 60).padStart(2, "0")}`
}

export default function MediaCard({ player: p }: { player: AstalMpris.Player }) {
  const art = coverArt(p)
  const position = createBinding(p, "position")
  const length = createBinding(p, "length")
  const playing = createBinding(p, "playbackStatus")(
    (st) => st === AstalMpris.PlaybackStatus.PLAYING,
  )
  return (
    <box class="media" spacing={12}>
      <box
        class="cover"
        valign={Gtk.Align.START}
        css={art((f) => (f ? `background-image: url("file://${f}");` : ""))}
      />
      <box orientation={Gtk.Orientation.VERTICAL} hexpand widthRequest={230}>
        <box spacing={8}>
          <label
            class="media-title"
            label={createBinding(p, "title")}
            hexpand
            xalign={0}
            maxWidthChars={24}
            ellipsize={Pango.EllipsizeMode.END}
          />
          <label class="media-player" label={""} valign={Gtk.Align.START} />
        </box>
        <label
          class="media-artist"
          label={createBinding(p, "artist")}
          xalign={0}
          maxWidthChars={28}
          ellipsize={Pango.EllipsizeMode.END}
        />
        <box vexpand />
        <slider
          class="media-seek"
          min={0}
          max={length((l) => Math.max(l, 1))}
          value={position}
          sensitive={createBinding(p, "canSeek")}
          onChangeValue={(_self, _scroll, value) => p.set_position(value)}
        />
        <centerbox>
          <label $type="start" class="media-time" label={position(fmt)} />
          <box $type="center" spacing={4}>
            <button class="media-btn" onClicked={() => p.previous()}>
              <label label={""} />
            </button>
            <button class="media-btn" onClicked={() => p.play_pause()}>
              <label label={playing((pl) => (pl ? "" : ""))} />
            </button>
            <button class="media-btn" onClicked={() => p.next()}>
              <label label={""} />
            </button>
          </box>
          <label $type="end" class="media-time" label={length(fmt)} />
        </centerbox>
      </box>
    </box>
  )
}
