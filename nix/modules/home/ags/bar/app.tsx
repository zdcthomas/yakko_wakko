import app from "ags/gtk4/app"
import { For, This, createBinding } from "ags"
import style from "./style.scss"
import Bar from "./Bar"
import { Popups } from "./Notifications"
import { RICES, applyRice, rice } from "./rices"

app.start({
  instanceName: "bar",
  css: style,
  // Adwaita, not the system theme, so a theme change cannot restyle the bar.
  gtkTheme: "Adwaita",
  // `ags request -i bar rice <name>`, e.g. from a keybind; no name lists them.
  requestHandler(argv, res) {
    const [cmd, ...rest] = argv
    if (cmd !== "rice") return res("usage: rice [name]")
    const name = rest.join(" ")
    if (!name) return res(RICES.map((r) => r.name).join("\n"))
    if (!RICES.some((r) => r.name === name)) return res(`no rice "${name}"`)
    applyRice(name)
    res(name)
  },
  main() {
    applyRice(rice.get(), true)
    return (
      <For each={createBinding(app, "monitors")}>
        {(monitor) => (
          <This this={app}>
            <Bar gdkmonitor={monitor} />
            <Popups gdkmonitor={monitor} />
          </This>
        )}
      </For>
    )
  },
})
