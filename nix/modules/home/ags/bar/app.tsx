import app from "ags/gtk4/app"
import { For, This, createBinding } from "ags"
import style from "./style.scss"
import Bar from "./Bar"
import { Popups } from "./Notifications"

app.start({
  instanceName: "bar",
  css: style,
  // Adwaita, not the system theme, so a theme change cannot restyle the bar.
  gtkTheme: "Adwaita",
  main() {
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
