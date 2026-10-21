// The bar is the notification daemon (it replaces mako), so it draws the
// popups and keeps the history. Notifications never need a click: a popup
// hides itself after its timeout, and the notification stays in the history
// popover until "Clear".
import app from "ags/gtk4/app"
import Astal from "gi://Astal?version=4.0"
import Gtk from "gi://Gtk?version=4.0"
import Gdk from "gi://Gdk?version=4.0"
import GLib from "gi://GLib"
import Pango from "gi://Pango"
import AstalNotifd from "gi://AstalNotifd"
import { For, createBinding, createState, onCleanup } from "ags"
import { timeout } from "ags/time"

const notifd = AstalNotifd.get_default()
// notifd would drop a notification when it expires, which would also drop it
// from the history; popups run their own timer instead.
notifd.ignoreTimeout = true

const POPUP_MS = 4000 // mako's default-timeout before this
const HISTORY_MAX = 50

const time = (n: AstalNotifd.Notification) =>
  GLib.DateTime.new_from_unix_local(n.time).format("%H:%M")!

function Card({ n, onClose }: { n: AstalNotifd.Notification; onClose?: () => void }) {
  const urgent = n.urgency === AstalNotifd.Urgency.CRITICAL
  return (
    <button class={urgent ? "notif urgent" : "notif"} onClicked={() => onClose?.()}>
      <box orientation={Gtk.Orientation.VERTICAL} spacing={2} widthRequest={320}>
        <box spacing={8}>
          <label class="notif-app" label={n.appName || "notification"} hexpand xalign={0} />
          <label class="notif-time" label={time(n)} />
        </box>
        <label class="notif-summary" label={n.summary} xalign={0} wrap maxWidthChars={40} />
        <label
          class="notif-body"
          label={n.body}
          visible={n.body !== ""}
          xalign={0}
          wrap
          maxWidthChars={40}
          lines={4}
          ellipsize={Pango.EllipsizeMode.END}
          useMarkup={false}
        />
      </box>
    </button>
  )
}

// Popups: newest on top. A critical notification stays until clicked.
const [popups, setPopups] = createState<AstalNotifd.Notification[]>([])
const hide = (n: AstalNotifd.Notification) => setPopups(popups.get().filter((p) => p !== n))

notifd.connect("notified", (_d, id) => {
  const n = notifd.get_notification(id)
  if (!n) return
  setPopups([n, ...popups.get().filter((p) => p.id !== id)])
  if (n.urgency !== AstalNotifd.Urgency.CRITICAL)
    timeout(n.expireTimeout > 0 ? n.expireTimeout : POPUP_MS, () => hide(n))
  // Keep the history bounded: dismiss the oldest beyond the limit.
  const all = notifd.notifications.sort((a, b) => b.time - a.time)
  all.slice(HISTORY_MAX).forEach((old) => old.dismiss())
})
notifd.connect("resolved", (_d, id) => setPopups(popups.get().filter((p) => p.id !== id)))

export function Popups({ gdkmonitor }: { gdkmonitor: Gdk.Monitor }) {
  let win: Astal.Window
  onCleanup(() => win.destroy())
  const { TOP, RIGHT } = Astal.WindowAnchor
  return (
    <window
      $={(self) => (win = self)}
      visible={popups((p) => p.length > 0)}
      namespace="notifications"
      class="popups"
      gdkmonitor={gdkmonitor}
      layer={Astal.Layer.OVERLAY}
      anchor={TOP | RIGHT}
      application={app}
    >
      <box orientation={Gtk.Orientation.VERTICAL} spacing={8}>
        <For each={popups}>{(n) => <Card n={n} onClose={() => hide(n)} />}</For>
      </box>
    </window>
  )
}

// The bell pill: a plain glyph, no unread count. Opens the history.
export function History() {
  const history = createBinding(notifd, "notifications")((ns) =>
    [...ns].sort((a, b) => b.time - a.time),
  )
  return (
    <menubutton class="pill">
      <label label={""} />
      <popover>
        <box class="dash" orientation={Gtk.Orientation.VERTICAL} spacing={8}>
          <box>
            <label class="dash-date" label="Notifications" hexpand xalign={0} />
            <button
              class="clear"
              label="Clear"
              onClicked={() => notifd.notifications.forEach((n) => n.dismiss())}
            />
          </box>
          <label class="empty" label="Nothing yet" visible={history((h) => h.length === 0)} />
          <Gtk.ScrolledWindow
            hscrollbarPolicy={Gtk.PolicyType.NEVER}
            propagateNaturalHeight
            maxContentHeight={500}
            visible={history((h) => h.length > 0)}
          >
            <box orientation={Gtk.Orientation.VERTICAL} spacing={6}>
              <For each={history}>{(n) => <Card n={n} onClose={() => n.dismiss()} />}</For>
            </box>
          </Gtk.ScrolledWindow>
        </box>
      </popover>
    </menubutton>
  )
}
