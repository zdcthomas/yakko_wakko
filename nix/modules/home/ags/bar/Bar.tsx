// The top bar: waybar's pill layout, with a capsule in the centre that holds
// the workspaces and the focused window. The clock sits at the far right.
import app from "ags/gtk4/app"
import Astal from "gi://Astal?version=4.0"
import Gtk from "gi://Gtk?version=4.0"
import Gdk from "gi://Gdk?version=4.0"
import Pango from "gi://Pango"
import {
  For,
  createBinding,
  createComputed,
  onCleanup,
  type Accessor,
} from "ags"
import * as s from "./services"
import AstalTray from "gi://AstalTray"
import AstalMpris from "gi://AstalMpris"
import { History } from "./Notifications"
import { RICES, applyRice, rice } from "./rices"
import Timer from "./Timer"
import MediaCard from "./Media"

function Tray({ cls = "tray" }: { cls?: string }) {
  const tray = AstalTray.get_default()
  const init = (btn: Gtk.MenuButton, item: AstalTray.TrayItem) => {
    btn.menuModel = item.menuModel
    btn.insert_action_group("dbusmenu", item.actionGroup)
    item.connect("notify::action-group", () =>
      btn.insert_action_group("dbusmenu", item.actionGroup),
    )
  }
  return (
    <box class={cls} spacing={8}>
      <For each={createBinding(tray, "items")}>
        {(item) => (
          <menubutton $={(self) => init(self, item)}>
            <image gicon={createBinding(item, "gicon")} />
          </menubutton>
        )}
      </For>
    </box>
  )
}

// Scroll over the pill to step brightness by 5%. Under Hyprland a wheel
// notch arrives as a 15px surface scroll, and a touchpad as many small ones,
// so add them up and step once per 15px: one notch, one step.
function Brightness() {
  const scroll = new Gtk.EventControllerScroll({
    flags: Gtk.EventControllerScrollFlags.VERTICAL,
  })
  let acc = 0
  scroll.connect("scroll", (c, _dx, dy) => {
    acc += c.get_unit() === Gdk.ScrollUnit.WHEEL ? dy : dy / 15
    const steps = Math.trunc(acc)
    if (steps !== 0) {
      acc -= steps
      s.setBrightness(s.brightness.get() - steps * 5)
    }
    return true
  })
  return (
    <box class="pill" spacing={4} $={(self) => self.add_controller(scroll)}>
      <label label={"\uf185"} />
      <label label={s.brightness((b) => `${b}%`)} />
    </box>
  )
}

// The network pill: click it to open nmgui. nm-applet's own menu stays in
// the tray.
function Network() {
  return (
    <button class="pill net" onClicked={s.openNetApp} tooltipText="networks (nmgui)">
      <box spacing={6}>
        <image iconName={s.netIcon} />
        {s.ssid && <label label={s.ssid} />}
      </box>
    </button>
  )
}

// One row per toggle in the dropdown: glyph, name, and its on/off state.
function Toggle(props: {
  glyph: string
  name: string
  on: Accessor<boolean>
  onClicked: () => void
}) {
  return (
    <button
      class={props.on((o) => (o ? "toggle-row on" : "toggle-row"))}
      onClicked={props.onClicked}
    >
      <box spacing={10}>
        <label label={props.glyph} widthChars={2} />
        <label label={props.name} hexpand xalign={0} />
        <label label={props.on((o) => (o ? "on" : "off"))} />
      </box>
    </button>
  )
}

// The rice picker in the gear dropdown: one row per look, with its swatch.
function RicePicker() {
  return (
    <box orientation={Gtk.Orientation.VERTICAL} spacing={2}>
      <label class="section" label="Rice" xalign={0} />
      {RICES.map((r) => (
        <button
          class={rice((cur) => (cur === r.name ? "toggle-row on" : "toggle-row"))}
          onClicked={() => applyRice(r.name)}
        >
          <box spacing={10}>
            <box class="swatch" spacing={0} valign={Gtk.Align.CENTER}>
              {r.swatch.map((c) => (
                <box css={`background: ${c}; min-width: 9px; min-height: 12px;`} />
              ))}
            </box>
            <label label={r.name} hexpand xalign={0} />
            <label label={rice((cur) => (cur === r.name ? "\uf00c" : ""))} />
          </box>
        </button>
      ))}
    </box>
  )
}

// The waybar one-click toggles, folded into one dropdown. The pill shows
// the glyph of each toggle that is on, so the state stays visible.
function Toggles() {
  const glyphs = { airpods: "\uf025", awake: "\uf06e", gamemode: "\uf11b" }
  const active = createComputed(() =>
    [
      s.airpods() && glyphs.airpods,
      s.keepAwake() && glyphs.awake,
      s.gamemode() && glyphs.gamemode,
    ]
      .filter(Boolean)
      .join(" "),
  )
  return (
    <menubutton class="pill toggles">
      <box spacing={6}>
        <label label={"\uf013"} />
        <label
          class="active"
          label={active}
          visible={active((a) => a !== "")}
        />
      </box>
      <popover>
        <box
          class="dash"
          orientation={Gtk.Orientation.VERTICAL}
          spacing={4}
          widthRequest={220}
        >
          <Toggle
            glyph={glyphs.airpods}
            name="AirPods"
            on={s.airpods}
            onClicked={s.toggleAirpods}
          />
          <Toggle
            glyph={glyphs.awake}
            name="Keep screen on"
            on={s.keepAwake}
            onClicked={s.toggleKeepAwake}
          />
          <Toggle
            glyph={glyphs.gamemode}
            name="Game mode"
            on={s.gamemode}
            onClicked={s.toggleGamemode}
          />
          <Gtk.Separator />
          <RicePicker />
        </box>
      </popover>
    </menubutton>
  )
}

// CPU, memory, disk and temperature as four thin vertical meters in one
// pill. Each turns yellow, then red, past its thresholds; the popover has the
// numbers. Temperature fills against 100 °C.
const SYS = [
  { key: "cpu", label: "cpu", value: s.cpu, warn: 70, crit: 90, unit: "%" },
  { key: "mem", label: "mem", value: s.mem, warn: 75, crit: 90, unit: "%" },
  { key: "disk", label: "disk", value: s.disk, warn: 80, crit: 90, unit: "%" },
  { key: "temp", label: "temp", value: s.temp, warn: 80, crit: 90, unit: "°C" },
]
const level = (v: number, warn: number, crit: number) =>
  v >= crit ? "crit" : v >= warn ? "warn" : "ok"

function System() {
  const tip = createComputed(() =>
    SYS.map((m) => `${m.label} ${m.value()}${m.unit}`).join("   "),
  )
  return (
    <menubutton class="pill sys" tooltipText={tip}>
      <box spacing={3} valign={Gtk.Align.CENTER}>
        {SYS.map((m) => (
          <levelbar
            class={m.value((v) => `mini ${level(v, m.warn, m.crit)}`)}
            orientation={Gtk.Orientation.VERTICAL}
            inverted
            value={m.value((v) => Math.min(v, 100) / 100)}
          />
        ))}
      </box>
      <popover>
        <box
          class="dash"
          orientation={Gtk.Orientation.VERTICAL}
          spacing={10}
          widthRequest={260}
        >
          {SYS.map((m) => (
            <box
              class={m.value((v) => `meter ${level(v, m.warn, m.crit)}`)}
              spacing={8}
            >
              <label
                class="meter-label"
                label={m.label}
                widthChars={5}
                xalign={0}
              />
              <levelbar
                hexpand
                valign={Gtk.Align.CENTER}
                value={m.value((v) => Math.min(v, 100) / 100)}
              />
              <label
                label={m.value((v) => `${v}${m.unit}`)}
                widthChars={5}
                xalign={1}
              />
            </box>
          ))}
        </box>
      </popover>
    </menubutton>
  )
}

// Shown only while an app records; red when live, dim when muted. Click mutes.
function Mic() {
  return (
    <button
      class={s.micMuted((m) => (m ? "pill mic muted" : "pill mic live"))}
      visible={s.recording}
      onClicked={s.toggleMic}
      tooltipText={s.micMuted((m) =>
        m ? "microphone muted" : "microphone live",
      )}
    >
      <label label={s.micMuted((m) => (m ? "\uf131" : "\uf130"))} />
    </button>
  )
}

// Spotify's track, while it plays or is paused. Click opens the media card;
// scroll skips forward or back.
function NowPlaying() {
  return (
    <box>
      <For each={s.spotify}>
        {(p: AstalMpris.Player) => {
          const scroll = new Gtk.EventControllerScroll({
            flags:
              Gtk.EventControllerScrollFlags.VERTICAL |
              Gtk.EventControllerScrollFlags.DISCRETE,
          })
          scroll.connect("scroll", (_c, _dx, dy) => {
            if (dy > 0) p.next()
            else if (dy < 0) p.previous()
            return true
          })
          const artist = createBinding(p, "artist")
          const title = createBinding(p, "title")
          const track = createComputed(() =>
            artist() ? `${title()} — ${artist()}` : title(),
          )
          const status = createBinding(p, "playbackStatus")
          return (
            <menubutton
              class={status((st) =>
                st === AstalMpris.PlaybackStatus.PLAYING ? "np" : "np paused",
              )}
              $={(self) => self.add_controller(scroll)}
              visible={status((st) => st !== AstalMpris.PlaybackStatus.STOPPED)}
            >
              <box spacing={6}>
                <label class="np-glyph" label={"\uf001"} />
                <label
                  label={track}
                  maxWidthChars={32}
                  ellipsize={Pango.EllipsizeMode.END}
                />
              </box>
              <popover>
                <box class="dash">
                  <MediaCard player={p} />
                </box>
              </popover>
            </menubutton>
          )
        }}
      </For>
    </box>
  )
}

function Meter({ label, value }: { label: string; value: Accessor<number> }) {
  return (
    <box class="meter" spacing={8}>
      <label class="meter-label" label={label} widthChars={5} xalign={0} />
      <levelbar
        hexpand
        valign={Gtk.Align.CENTER}
        value={value((v) => v / 100)}
      />
      <label label={value((v) => `${v}%`)} widthChars={4} xalign={1} />
    </box>
  )
}

// The clock, at the far right of the bar. Click it for the month calendar.
// Gtk.Calendar has no intrinsic element, so it goes in as a class component.
function Clock() {
  return (
    <menubutton class="pill clock">
      <label class="time" label={s.clock("%H:%M")} />
      <popover>
        <box class="dash" orientation={Gtk.Orientation.VERTICAL} spacing={8}>
          <label class="dash-date" xalign={0} label={s.clock("%A %d %B")} />
          <Gtk.Calendar />
        </box>
      </popover>
    </menubutton>
  )
}

function Capsule() {
  return (
    <box class="capsule" valign={Gtk.Align.CENTER} spacing={14}>
      <box class="dots" spacing={6} valign={Gtk.Align.CENTER}>
        <For each={s.workspaces}>
          {(ws) => (
            <button
              class={s.focusedWs((f) => (f === ws ? "dot active" : "dot"))}
              onClicked={() => ws.focus()}
              tooltipText={`workspace ${ws.id}`}
            />
          )}
        </For>
      </box>
      <label
        class="title"
        maxWidthChars={48}
        ellipsize={Pango.EllipsizeMode.END}
        label={s.focusedClient((c) => c?.title ?? "desktop")}
      />
      <NowPlaying />
      <label
        class="submap"
        label={s.submap}
        visible={s.submap((m) => m !== "")}
      />
    </box>
  )
}

export default function Bar({ gdkmonitor }: { gdkmonitor: Gdk.Monitor }) {
  let win: Astal.Window
  // Windows are not destroyed with their scope; <For> runs this when the
  // monitor goes away.
  onCleanup(() => win.destroy())
  const { TOP, LEFT, RIGHT } = Astal.WindowAnchor

  return (
    <window
      $={(self) => (win = self)}
      visible
      namespace="bar"
      gdkmonitor={gdkmonitor}
      exclusivity={Astal.Exclusivity.EXCLUSIVE}
      anchor={TOP | LEFT | RIGHT}
      application={app}
    >
      <centerbox>
        <box $type="start">
          <label
            class={`pill mode ${s.mode}`}
            label={s.modeIcon}
            tooltipText={`mode: ${s.mode}`}
          />
          <Network />
          <Tray cls="pill tray" />
          <Toggles />
          <History />
        </box>
        <box $type="center">
          <Capsule />
        </box>
        <box $type="end">
          <Mic />
          <button
            class="pill"
            onClicked={s.toggleMute}
            tooltipText={s.outputDesc}
          >
            <box spacing={4}>
              <image iconName={s.volumeIcon} />
              <label
                label={s.outputName}
                visible={s.outputName((n) => n !== "")}
                maxWidthChars={16}
                ellipsize={Pango.EllipsizeMode.END}
              />
              <label label={s.volumeText} />
            </box>
          </button>
          <Brightness />
          <System />
          <box class="pill" spacing={4} visible={s.batPresent}>
            <image iconName={s.batIcon} />
            <label label={s.batText} />
          </box>
          <Timer />
          <Clock />
        </box>
      </centerbox>
    </window>
  )
}
