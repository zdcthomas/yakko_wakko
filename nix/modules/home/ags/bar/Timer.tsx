// A countdown timer that starts Spotify when it runs out. The pill shows the
// time left while it runs and a bell once it is done; open it to dismiss.
// Also `ags request -i bar timer <minutes>`, or `timer stop`.
import Gtk from "gi://Gtk?version=4.0"
import { createState } from "ags"
import { interval } from "ags/time"
import { execAsync } from "ags/process"
import { playMusic } from "./services"

const PRESETS = [5, 10, 25, 45, 60]

// Seconds left, 0 while no timer runs.
const [left, setLeft] = createState(0)
const [done, setDone] = createState(false)
let tick: ReturnType<typeof interval> | null = null

export function stopTimer() {
  tick?.cancel()
  tick = null
  setLeft(0)
}

// Count against the end time, not by decrements, so a suspend or a late tick
// does not stretch the timer.
export function startTimer(minutes: number) {
  stopTimer()
  setDone(false)
  const end = Date.now() + minutes * 60_000
  tick = interval(1000, () => {
    const l = Math.ceil((end - Date.now()) / 1000)
    if (l > 0) return setLeft(l)
    stopTimer()
    setDone(true)
    playMusic()
    execAsync(["notify-send", "-a", "Timer", "Time's up", `${minutes} min timer done`]).catch(
      console.error,
    )
  })
}

const fmt = (t: number) => {
  const h = Math.floor(t / 3600)
  const m = Math.floor((t % 3600) / 60)
  const ss = String(t % 60).padStart(2, "0")
  return h ? `${h}:${String(m).padStart(2, "0")}:${ss}` : `${m}:${ss}`
}

export default function Timer() {
  let btn: Gtk.MenuButton
  let spin: Gtk.SpinButton
  const start = (minutes: number) => {
    startTimer(minutes)
    btn.popdown()
  }
  return (
    <menubutton
      $={(self) => (btn = self)}
      class={done((d) => (d ? "pill timer done" : "pill timer"))}
    >
      <box spacing={6}>
        <label label={done((d) => (d ? "" : ""))} />
        <label label={left(fmt)} visible={left((l) => l > 0)} />
      </box>
      <popover $={(self) => self.connect("show", () => setDone(false))}>
        <box
          class="dash"
          orientation={Gtk.Orientation.VERTICAL}
          spacing={4}
          widthRequest={240}
        >
          <label class="section" label="Timer" xalign={0} />
          <box spacing={4} homogeneous>
            {PRESETS.map((m) => (
              <button class="toggle-row" onClicked={() => start(m)}>
                <label label={`${m}m`} />
              </button>
            ))}
          </box>
          <box spacing={6}>
            <Gtk.SpinButton
              $={(self) => (spin = self)}
              hexpand
              numeric
              adjustment={
                new Gtk.Adjustment({ lower: 1, upper: 600, stepIncrement: 1, value: 20 })
              }
              onActivate={() => start(spin.get_value_as_int())}
            />
            <label label="min" />
            <button class="toggle-row" onClicked={() => start(spin.get_value_as_int())}>
              <label label="start" />
            </button>
          </box>
          <button class="toggle-row" visible={left((l) => l > 0)} onClicked={stopTimer}>
            <box spacing={10}>
              <label label={""} widthChars={2} />
              <label label={left((l) => `cancel (${fmt(l)} left)`)} hexpand xalign={0} />
            </box>
          </button>
        </box>
      </popover>
    </menubutton>
  )
}
