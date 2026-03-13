pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import "."

Singleton {
    id: metrics

    property bool netConnected: false
    property bool hypridleEnabled: false
    property int volumePercent: 0
    property int micPercent: 0
    property int cpuPercent: 0
    property int ramPercent: 0
    property string ramUsedGB: ""

    function trimText(value) {
        if (value === undefined || value === null)
            return "";
        return String(value).trim();
    }

    function rgbaFromHex(hex, alpha) {
        var clean = trimText(hex);
        if (!clean.length)
            return "#00000000";
        if (clean[0] === "#")
            clean = clean.substring(1);
        if (clean.length !== 6)
            return "#00000000";
        var a = Math.max(0, Math.min(255, Math.round(alpha * 255)));
        var ahex = a.toString(16);
        if (ahex.length < 2)
            ahex = "0" + ahex;
        return "#" + ahex + clean;
    }

    function applyWalColors(raw) {
        if (!raw || !trimText(raw).length)
            return;
        try {
            var data = JSON.parse(raw);
            var special = data.special || {};
            var colors = data.colors || {};
            var background = special.background || "#141418";
            var foreground = special.foreground || "#f5f7ff";
            var accent = colors.color7 || foreground;

            AppState.barBgColor = rgbaFromHex(background, 0.50);
            AppState.barBorderColor = rgbaFromHex(accent, 0.35);
            AppState.barTextColor = foreground;
            AppState.buttonHoverColor = rgbaFromHex(accent, 0.15);
            AppState.buttonActiveColor = rgbaFromHex(accent, 0.30);
            AppState.buttonActiveBorderColor = rgbaFromHex(accent, 0.55);
            AppState.tooltipBgColor = rgbaFromHex(background, 1.0);
            AppState.notifBgColor = rgbaFromHex(background, 0.92);
            AppState.notifBorderColor = rgbaFromHex(accent, 0.35);
            AppState.notifTextColor = foreground;
            AppState.notifSubTextColor = rgbaFromHex(foreground, 0.60);
            AppState.notifAccentColor = rgbaFromHex(colors.color4 || accent, 0.60);
            AppState.notifHoverColor = rgbaFromHex(accent, 0.15);
            AppState.notifUrgentColor = colors.color1 || "#e05555";
        } catch (e) {}
    }

    // Called by TopBar's idle-toggle button after toggling to refresh state
    function pollHypridle() {
        hypridleStateProc.running = true;
    }

    Process {
        id: netStatusProc
        command: ["bash", "-lc", "nmcli -t -f STATE g 2>/dev/null | head -n1"]
        stdout: StdioCollector {
            id: netStatusOut
        }
        onExited: metrics.netConnected = metrics.trimText(netStatusOut.text) === "connected"
    }

    Process {
        id: hypridleStateProc
        command: ["bash", "-lc", "pgrep -x hypridle >/dev/null && echo on || echo off"]
        stdout: StdioCollector {
            id: hypridleStateOut
        }
        onExited: metrics.hypridleEnabled = metrics.trimText(hypridleStateOut.text) === "on"
    }

    Process {
        id: volumeProc
        command: ["bash", "-lc", "pactl get-sink-volume @DEFAULT_SINK@ | grep -Eo '[0-9]+%' | head -n1 | tr -d '%' || echo 0"]
        stdout: StdioCollector {
            id: volumeOut
        }
        onExited: {
            var v = Number(metrics.trimText(volumeOut.text));
            if (!isNaN(v))
                metrics.volumePercent = v;
        }
    }

    Process {
        id: micProc
        command: ["bash", "-lc", "pactl get-source-volume @DEFAULT_SOURCE@ | grep -Eo '[0-9]+%' | head -n1 | tr -d '%' || echo 0"]
        stdout: StdioCollector {
            id: micOut
        }
        onExited: {
            var v = Number(metrics.trimText(micOut.text));
            if (!isNaN(v))
                metrics.micPercent = v;
        }
    }

    Process {
        id: cpuProc
        command: ["bash", "-lc", "top -bn1 | awk '/^%Cpu/ {print int($2+$4)}' || echo 0"]
        stdout: StdioCollector {
            id: cpuOut
        }
        onExited: {
            var v = Number(metrics.trimText(cpuOut.text));
            if (!isNaN(v))
                metrics.cpuPercent = v;
        }
    }

    Process {
        id: ramProc
        command: ["bash", "-lc", "free | awk '/Mem:/ {printf \"%d %.1f\", ($3/$2)*100, $3/1024/1024}' || echo 0 0"]
        stdout: StdioCollector {
            id: ramOut
        }
        onExited: {
            var parts = metrics.trimText(ramOut.text).split(" ");
            var v = Number(parts[0]);
            if (!isNaN(v))
                metrics.ramPercent = v;
            if (parts.length > 1)
                metrics.ramUsedGB = parts[1];
        }
    }

    Process {
        id: hyprBlurRuleProc
        command: ["bash", "-lc", "hyprctl keyword layerrule 'blur,quickshell' >/dev/null 2>&1; hyprctl keyword layerrule 'ignorealpha 0.2,quickshell' >/dev/null 2>&1"]
    }

    Process {
        id: walColorsProc
        command: ["bash", "-lc", "cat \"$HOME/.cache/wal/colors.json\" 2>/dev/null"]
        stdout: StdioCollector {
            id: walColorsOut
        }
        onExited: metrics.applyWalColors(walColorsOut.text)
    }

    Timer {
        interval: 500
        running: true
        repeat: true
        onTriggered: {
            volumeProc.running = true;
            micProc.running = true;
        }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: AppState.updateDate()
    }

    Timer {
        interval: 2500
        running: true
        repeat: true
        onTriggered: {
            netStatusProc.running = true;
            hypridleStateProc.running = true;
            cpuProc.running = true;
            ramProc.running = true;
        }
    }

    Timer {
        interval: 5000
        running: true
        repeat: true
        onTriggered: walColorsProc.running = true
    }

    Component.onCompleted: {
        AppState.updateDate();
        hyprBlurRuleProc.running = true;
        walColorsProc.running = true;
        netStatusProc.running = true;
        hypridleStateProc.running = true;
        volumeProc.running = true;
        micProc.running = true;
        cpuProc.running = true;
        ramProc.running = true;
    }
}
