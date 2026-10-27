// Pomodoro.qml — shared pomodoro timer state (one clock for all screens)
pragma Singleton
import QtQuick
import Quickshell

Scope {
    id: root

    // Two tracks the user can cycle with a middle click.
    readonly property var presets: [
        { label: "25/5",  focus: 25 * 60, brk: 5 * 60 },
        { label: "50/10", focus: 50 * 60, brk: 10 * 60 }
    ]
    property int presetIdx: 0
    readonly property var preset: presets[presetIdx]

    property string phase: "focus"          // "focus" or "break"
    property bool running: false
    property int remaining: preset.focus    // seconds left in the current phase

    readonly property int phaseLength: phase === "focus" ? preset.focus : preset.brk

    // "MM:SS" for the bar label.
    readonly property string display: {
        const m = Math.floor(remaining / 60);
        const s = remaining % 60;
        return (m < 10 ? "0" : "") + m + ":" + (s < 10 ? "0" : "") + s;
    }

    readonly property string soundDir: "/usr/share/sounds/freedesktop/stereo/"

    function notify(title, body) {
        Quickshell.execDetached(["notify-send", "-a", "Pomodoro", "-i", "alarm-symbolic", title, body]);
    }

    // Play a short cue via PipeWire; different sound per phase end.
    function chime(file) {
        Quickshell.execDetached(["pw-play", soundDir + file]);
    }

    // Left click: start / pause. Starting a finished timer re-arms it first.
    function toggle() {
        if (remaining <= 0) reset();
        running = !running;
    }

    // Right click: stop and refill the current phase.
    function reset() {
        running = false;
        remaining = phaseLength;
    }

    // Middle click: switch 25/5 <-> 50/10, back to a fresh focus block.
    function cyclePreset() {
        presetIdx = (presetIdx + 1) % presets.length;
        phase = "focus";
        running = false;
        remaining = preset.focus;
    }

    // One tick per second while running.
    Timer {
        interval: 1000
        repeat: true
        running: root.running
        onTriggered: {
            if (root.remaining > 0) root.remaining -= 1;
            if (root.remaining <= 0) {
                // Phase done: announce, swap phase, and pause so the user restarts deliberately.
                if (root.phase === "focus") {
                    root.phase = "break";
                    root.notify("집중 끝", "휴식 " + Math.floor(root.preset.brk / 60) + "분 — 화면에서 눈을 떼세요.");
                    root.chime("complete.oga");          // 집중 끝: 완료음
                } else {
                    root.phase = "focus";
                    root.notify("휴식 끝", "집중 " + Math.floor(root.preset.focus / 60) + "분 시작할 준비가 되면 클릭하세요.");
                    root.chime("alarm-clock-elapsed.oga"); // 휴식 끝: 알람음
                }
                root.running = false;
                root.remaining = root.phaseLength;
            }
        }
    }
}
