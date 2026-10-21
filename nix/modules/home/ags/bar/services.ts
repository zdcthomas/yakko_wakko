// Every value the bar shows, as accessors. The setters at the bottom of each
// section are the only things here that change the system.
import GLib from "gi://GLib"
import Gio from "gi://Gio"
import AstalHyprland from "gi://AstalHyprland"
import AstalBattery from "gi://AstalBattery"
import AstalWp from "gi://AstalWp"
import AstalNetwork from "gi://AstalNetwork"
import AstalBluetooth from "gi://AstalBluetooth"
import AstalMpris from "gi://AstalMpris"
import { createBinding, createComputed, createConnection, createExternal, createState } from "ags"
import { createPoll, interval } from "ags/time"
import { readFile } from "ags/file"
import { execAsync } from "ags/process"

export const hypr = AstalHyprland.get_default()
export const battery = AstalBattery.get_default()
export const wp = AstalWp.get_default()!
export const network = AstalNetwork.get_default()
export const bluetooth = AstalBluetooth.get_default()

export const workspaces = createBinding(hypr, "workspaces")((ws) =>
  ws.filter((w) => w.id > 0).sort((a, b) => a.id - b.id),
)
export const focusedWs = createBinding(hypr, "focusedWorkspace")
export const focusedClient = createBinding(hypr, "focusedClient")
export const submap = createConnection("", [hypr, "submap", (name) => name])

export const clock = (format: string) =>
  createPoll("", 1000, () => GLib.DateTime.new_now_local().format(format)!)

// /etc/yakko-mode is the same source waybar's custom/mode reads.
export const mode = (() => {
  try {
    return readFile("/etc/yakko-mode").trim()
  } catch {
    return "unknown"
  }
})()
export const modeIcon =
  { writing: "", making: "", open: "" }[mode] ?? "?"

let prevIdle = 0
let prevTotal = 0
export const cpu = createPoll(0, 2000, () => {
  const f = readFile("/proc/stat").split("\n")[0].split(/\s+/).slice(1).map(Number)
  const idle = f[3] + f[4]
  const total = f.reduce((a, b) => a + b, 0)
  const pct = total === prevTotal ? 0 : 1 - (idle - prevIdle) / (total - prevTotal)
  prevIdle = idle
  prevTotal = total
  return Math.round(pct * 100)
})

export const mem = createPoll(0, 4000, () => {
  const m = Object.fromEntries(
    readFile("/proc/meminfo")
      .split("\n")
      .map((l) => l.split(/:\s+/))
      .map(([k, v]) => [k, parseInt(v)]),
  )
  return Math.round((1 - m.MemAvailable / m.MemTotal) * 100)
})

export const batPct = createBinding(battery, "percentage")((p) => Math.round(p * 100))
export const batCharging = createBinding(battery, "charging")
export const batPresent = createBinding(battery, "isPresent")
export const batIcon = createBinding(battery, "batteryIconName")

const speaker = wp.defaultSpeaker
export const volume = createBinding(speaker, "volume")((v) => Math.round(v * 100))
export const muted = createBinding(speaker, "mute")
// A muted sink keeps its volume, so show "muted" rather than a level that is not heard.
export const volumeText = createComputed(() => (muted() ? "muted" : `${volume()}%`))
export const volumeIcon = createBinding(speaker, "volumeIcon")
// What the sound comes out of, shown only for a Bluetooth sink (node name
// bluez_output.*), e.g. the AirPods; the built-in sink's chipset name
// ("Ryzen HD Audio Controller Analog Stereo") says nothing, so it shows none.
// defaultSpeaker follows the default sink, so this updates on switch.
export const outputDesc = createBinding(speaker, "description")((d) => d ?? "")
const sinkName = createBinding(speaker, "name")
export const outputName = createComputed(() =>
  sinkName()?.startsWith("bluez_") ? outputDesc() : "",
)
export const toggleMute = () => speaker.set_mute(!speaker.mute)
export const setVolume = (v: number) => speaker.set_volume(v)

export const wifi = network.wifi
export const ssid = wifi ? createBinding(wifi, "ssid")((s) => s ?? "offline") : null
export const netIcon = wifi
  ? createBinding(wifi, "iconName")
  : createBinding(network.wired, "iconName")


export const batText = createComputed(
  () => `${batCharging() ? "+" : ""}${batPct()}%`,
)

// sysfs does not notify on backlight writes, so poll; the read is one small
// file. Writes go through brightnessctl, which asks logind for permission
// because /sys/class/backlight/*/brightness is root-owned. The state is set
// at once on a write, so fast scroll steps build on each other instead of on
// a poll that is up to a second old.
const backlight = GLib.build_filenamev(["/sys/class/backlight", GLib.Dir.open("/sys/class/backlight", 0).read_name() ?? ""])
const maxBrightness = Number(readFile(`${backlight}/max_brightness`)) || 1
const readBrightness = () =>
  Math.round((Number(readFile(`${backlight}/brightness`)) / maxBrightness) * 100)
const [brightness, setBrightnessState] = createState(readBrightness())
export { brightness }
let lastWrite = 0
interval(1000, () => {
  if (Date.now() - lastWrite > 1500) setBrightnessState(readBrightness())
})
export function setBrightness(pct: number) {
  const v = Math.min(100, Math.max(1, Math.round(pct)))
  lastWrite = Date.now()
  setBrightnessState(v)
  execAsync(["brightnessctl", "--quiet", "set", `${v}%`]).catch(console.error)
}

// ---- toggles ---------------------------------------------------------------
// The two scripts come from ../default.nix through `ags bundle --define`, so
// their store paths are baked into the bundle. The defaults keep `ags run`
// from the repo working, with the toggles as no-ops.
declare const AIRPODS_TOGGLE: string
declare const GAMEMODE_TOGGLE: string
const airpodsToggle = typeof AIRPODS_TOGGLE === "string" ? AIRPODS_TOGGLE : "true"
const gamemodeToggle = typeof GAMEMODE_TOGGLE === "string" ? GAMEMODE_TOGGLE : "true"

const AIRPODS = "2C:18:09:F3:C6:E0"
// Follow every device's "connected" so the state flips when the AirPods
// connect, even when another device keeps bluetooth.isConnected true.
export const airpods = createExternal(false, (set) => {
  const watched: Array<[AstalBluetooth.Device, number]> = []
  const check = () =>
    set(bluetooth.devices.some((d) => d.address === AIRPODS && d.connected))
  const watch = () => {
    watched.forEach(([d, id]) => d.disconnect(id))
    watched.length = 0
    for (const d of bluetooth.devices) watched.push([d, d.connect("notify::connected", check)])
    check()
  }
  const id = bluetooth.connect("notify::devices", watch)
  watch()
  return () => {
    bluetooth.disconnect(id)
    watched.forEach(([d, wid]) => d.disconnect(wid))
  }
})
export const toggleAirpods = () => execAsync([airpodsToggle]).catch(console.error)

// Game mode is "animations off"; the toggle script flips it and hyprctl
// reload restores the config, so ask Hyprland rather than track it here.
const [gamemode, setGamemode] = createState(false)
export { gamemode }
const readGamemode = () =>
  execAsync(["hyprctl", "-j", "getoption", "animations:enabled"])
    .then((out) => setGamemode(JSON.parse(out).int === 0))
    .catch(console.error)
readGamemode()
export const toggleGamemode = () =>
  execAsync([gamemodeToggle]).then(readGamemode).catch(console.error)

// Keep the screen on: hold a systemd idle inhibitor, which hypridle honours
// while ignore_systemd_inhibit is false (its default).
let inhibitor: Gio.Subprocess | null = null
const [keepAwake, setKeepAwake] = createState(false)
export { keepAwake }
export function toggleKeepAwake() {
  if (inhibitor) {
    inhibitor.force_exit()
    inhibitor = null
  } else {
    inhibitor = Gio.Subprocess.new(
      ["systemd-inhibit", "--what=idle", "--who=bar", "--why=keep screen on", "sleep", "infinity"],
      Gio.SubprocessFlags.NONE,
    )
  }
  setKeepAwake(inhibitor !== null)
}

// ---- system ----------------------------------------------------------------
// Each value is 0-100 so the bar can draw them as one row of meters.
export const disk = createPoll(0, 30000, () => {
  const info = Gio.File.new_for_path("/").query_filesystem_info("filesystem::size,filesystem::free", null)
  const size = info.get_attribute_uint64("filesystem::size")
  return Math.round((1 - info.get_attribute_uint64("filesystem::free") / size) * 100)
})

// k10temp's Tctl. hwmonN numbering shuffles across boots, so find it by its
// fixed PCI parent, the same path waybar used.
const hwmon = "/sys/devices/pci0000:00/0000:00:18.3/hwmon"
const tempFile = `${hwmon}/${GLib.Dir.open(hwmon, 0).read_name()}/temp1_input`
export const temp = createPoll(0, 3000, () => Math.round(Number(readFile(tempFile)) / 1000))

// ---- microphone --------------------------------------------------------------
// Shown only while some app records, like a phone's privacy dot.
export const recording = createBinding(wp.audio, "recorders")((r) => r.length > 0)
const mic = wp.defaultMicrophone
export const micMuted = createBinding(mic, "mute")
export const toggleMic = () => mic.set_mute(!mic.mute)

// ---- now playing -------------------------------------------------------------
// Only Spotify, and only while it plays.
const mpris = AstalMpris.get_default()
export const spotify = createBinding(mpris, "players")((ps) =>
  ps.filter((p) => p.busName === "org.mpris.MediaPlayer2.spotify"),
)
