// Rices: whole looks for the bar, its popups and Hyprland's window borders,
// switched at runtime from the gear dropdown. A rice re-declares the CSS
// variables from style.scss and may add rules of its own; Hyprland gets its
// border colours and rounding through `hyprctl keyword`, which a config
// reload undoes, so the rice is applied again on every reload. The choice is
// kept in $XDG_STATE_HOME/ags-bar/rice. Terminals and other apps keep the
// nix-colors palette: Nix writes theirs at build time.
import app from "ags/gtk4/app"
import GLib from "gi://GLib"
import { createState } from "ags"
import { readFile, writeFile } from "ags/file"
import { execAsync } from "ags/process"
import { hypr } from "./services"
import style from "./style.scss"

type Hypr = { active: string; inactive: string; rounding: number }
export type Rice = {
  name: string
  swatch: string[]
  vars?: Record<string, string>
  css?: string
  hypr?: Hypr
}

// Tray icons are the apps' own, mostly white, so a light rice gives the tray
// pill a dark ground of its own.
export const RICES: Rice[] = [
  // The nix-colors palette and the stylesheet defaults; Hyprland keeps its config.
  { name: "Nix colors", swatch: [] },
  {
    name: "Synthwave",
    swatch: ["#241b2f", "#ff7edb", "#36f9f6", "#fede5d"],
    vars: {
      bg: "#241b2f", bg1: "#34294f", bg2: "#495495", bg3: "#848bbd",
      fg: "#f8e8ff", "fg-bright": "#ffffff", red: "#fe4450", orange: "#ff8b39",
      yellow: "#fede5d", green: "#72f1b8", aqua: "#36f9f6", blue: "#2ee2fa",
      purple: "#ff7edb", "pill-bg": "#241b2f", "pill-border": "#ff7edb",
      "cap-bg": "#241b2f", "cap-border": "#36f9f6",
    },
    css: `.capsule .title, .capsule .np { color: #36f9f6; }`,
    hypr: { active: "ff7edb", inactive: "495495", rounding: 10 },
  },
  {
    name: "Phosphor",
    swatch: ["#0b0d07", "#ffb000", "#ffcc55", "#7a5400"],
    vars: {
      bg: "#0b0d07", bg1: "#1a1505", bg2: "#3d2b00", bg3: "#7a5400",
      fg: "#ffb000", "fg-bright": "#ffcc55", red: "#ff5f1f", orange: "#ff8c00",
      yellow: "#ffcc55", green: "#ffb000", aqua: "#ffb000", blue: "#ffb000",
      purple: "#ffb000", "pill-bg": "#0b0d07", "pill-border": "#0b0d07",
      "cap-bg": "#0b0d07", "cap-border": "#ffb000",
      "pill-radius": "0", "cap-radius": "0", "dot-radius": "0", "pop-radius": "0",
    },
    // No pills: just amber text on black, the capsule underlined.
    css: `.capsule { border-width: 0 0 1px 0; }`,
    hypr: { active: "ffb000", inactive: "3d2b00", rounding: 0 },
  },
  {
    name: "Brutalist",
    swatch: ["#efece3", "#111111", "#ff4b2b", "#ffffff"],
    vars: {
      bg: "#ffffff", bg1: "#efece3", bg2: "#111111", bg3: "#777777",
      fg: "#111111", "fg-bright": "#000000", red: "#ff4b2b", orange: "#ff8a00",
      yellow: "#ffd400", green: "#00a35c", aqua: "#111111", blue: "#2b59ff",
      purple: "#8a2be2", "pill-bg": "#ffffff", "pill-border": "#111111",
      "cap-bg": "#ff4b2b", "cap-border": "#111111",
      "pill-radius": "0", "cap-radius": "0", "dot-radius": "0", "pop-radius": "0",
      shadow: "2px 2px 0 #111111",
    },
    css: `.capsule .title, .capsule .np, .capsule .np-glyph { color: #111111; }
.capsule .dot { background: rgba(17,17,17,0.35); }
.capsule .dot.active { background: #111111; }
levelbar trough { background: #d6d3ca; }
.pill.tray { background: #111111; }`,
    hypr: { active: "111111", inactive: "777777", rounding: 0 },
  },
  {
    name: "Riso",
    swatch: ["#fbf3e4", "#ffb3c7", "#b8f0d8", "#cdbdff"],
    vars: {
      bg: "#fbf3e4", bg1: "#f3e6cc", bg2: "#3a2e5c", bg3: "#8a7fa8",
      fg: "#3a2e5c", "fg-bright": "#2a1f4a", red: "#e8457a", orange: "#ff8a5b",
      yellow: "#f2b705", green: "#3a9d74", aqua: "#e8457a", blue: "#4b7bec",
      purple: "#7d5ba6", "pill-bg": "#ffb3c7", "pill-border": "#3a2e5c",
      "cap-bg": "#ffffff", "cap-border": "#3a2e5c",
      "pill-radius": "999px", shadow: "2px 2px 0 #3a2e5c",
    },
    // Each pill its own pastel, in turn.
    css: `.pill:nth-child(4n+2) { background: #b8f0d8; }
.pill:nth-child(4n+3) { background: #ffe48a; }
.pill:nth-child(4n) { background: #cdbdff; }
.capsule { border-style: dashed; }
.pill.tray { background: #3a2e5c; }`,
    hypr: { active: "3a2e5c", inactive: "8a7fa8", rounding: 14 },
  },
  {
    name: "Game Boy",
    swatch: ["#0f380f", "#306230", "#8bac0f", "#9bbc0f"],
    vars: {
      bg: "#306230", bg1: "#0f380f", bg2: "#8bac0f", bg3: "#5a8a1f",
      fg: "#9bbc0f", "fg-bright": "#c4e04a", red: "#e0f8d0", orange: "#c4e04a",
      yellow: "#c4e04a", green: "#9bbc0f", aqua: "#9bbc0f", blue: "#8bac0f",
      purple: "#8bac0f", "pill-bg": "#306230", "pill-border": "#8bac0f",
      "cap-bg": "#8bac0f", "cap-border": "#0f380f",
      "pill-radius": "0", "cap-radius": "0", "dot-radius": "0", "pop-radius": "0",
    },
    css: `.capsule .title, .capsule .np, .capsule .np-glyph { color: #0f380f; }
.capsule .dot { background: #306230; }
.capsule .dot.active { background: #0f380f; }
levelbar trough { background: #0f380f; }`,
    hypr: { active: "8bac0f", inactive: "306230", rounding: 0 },
  },
  {
    name: "Windows 95",
    swatch: ["#c0c0c0", "#000080", "#008080", "#ffffff"],
    vars: {
      bg: "#c0c0c0", bg1: "#dfdfdf", bg2: "#808080", bg3: "#808080",
      fg: "#000000", "fg-bright": "#000000", red: "#800000", orange: "#808000",
      yellow: "#808000", green: "#008000", aqua: "#000080", blue: "#000080",
      purple: "#800080", "pill-bg": "#c0c0c0", "pill-border": "#808080",
      "cap-bg": "#000080", "cap-border": "#808080",
      "pill-radius": "0", "cap-radius": "0", "dot-radius": "0", "pop-radius": "0",
    },
    // Raised bevels on pills and popovers, a sunken one on the capsule.
    css: `.pill, popover > contents, .notif { border-color: #ffffff #404040 #404040 #ffffff; }
.capsule { border-color: #404040 #ffffff #ffffff #404040; }
.capsule .title, .capsule .np, .capsule .np-glyph { color: #ffffff; }
.capsule .dot { background: #808080; }
.capsule .dot.active { background: #ffffff; }
.pill.tray { background: #808080; border-color: #404040 #ffffff #ffffff #404040; }`,
    hypr: { active: "000080", inactive: "808080", rounding: 0 },
  },
]

const stateFile = `${GLib.get_user_state_dir()}/ags-bar/rice`
const saved = (() => {
  try {
    return readFile(stateFile).trim()
  } catch {
    return ""
  }
})()
const [rice, setRice] = createState(RICES.some((r) => r.name === saved) ? saved : RICES[0].name)
export { rice }

const riceCss = (r: Rice) => {
  const vars = Object.entries(r.vars ?? {})
    .map(([k, v]) => `  --${k}: ${v};`)
    .join("\n")
  return `window, popover {\n${vars}\n}\n${r.css ?? ""}`
}

const hyprApply = (h: Hypr) =>
  execAsync([
    "hyprctl", "--batch",
    `keyword general:col.active_border rgb(${h.active}); ` +
      `keyword general:col.inactive_border rgb(${h.inactive}); ` +
      `keyword decoration:rounding ${h.rounding}`,
  ]).catch(console.error)

// A rice without its own Hyprland settings means "what the config says", so
// a config reload is the way back to it.
function applyHypr(r: Rice, reloading = false) {
  if (r.hypr) hyprApply(r.hypr)
  else if (!reloading) execAsync(["hyprctl", "reload"]).catch(console.error)
}

// `startup` skips the Hyprland reload that "Nix colors" would otherwise run:
// at login the config is already in force, and a reload would also undo
// game mode.
export function applyRice(name: string, startup = false) {
  const r = RICES.find((x) => x.name === name) ?? RICES[0]
  // One sheet, rice last, so its declarations win over the defaults.
  app.apply_css(style + "\n" + riceCss(r), true)
  applyHypr(r, startup)
  setRice(r.name)
  try {
    GLib.mkdir_with_parents(GLib.path_get_dirname(stateFile), 0o755)
    writeFile(stateFile, r.name)
  } catch (e) {
    console.error(e)
  }
}

// Hyprland's reload resets the keywords; put the rice back.
hypr.connect("config-reloaded", () => {
  const r = RICES.find((x) => x.name === rice.get())
  if (r) applyHypr(r, true)
})
