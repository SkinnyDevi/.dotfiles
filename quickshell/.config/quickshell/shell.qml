import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import Quickshell.Services.Notifications

ShellRoot {
    id: root

    property string fontFamily: "SpaceMono Nerd Font"

    property bool notifPanelOpen: false
    property var toastNotification: null
    property bool toastVisible: false

    // updated by pywal
    property color notifBgColor: "#e8141418"
    property color notifBorderColor: "#35ffffff"
    property color notifTextColor: "#f5f7ff"
    property color notifSubTextColor: "#99f5f7ff"
    property color notifAccentColor: "#55ffffff"
    property color notifHoverColor: "#18ffffff"
    property color notifUrgentColor: "#e05555"

    onNotifPanelOpenChanged: {
        if (notifPanelOpen)
            toastVisible = false;
    }

    NotificationServer {
        id: notifServer
        actionsSupported: true
        imageSupported: true
        keepOnReload: true
        onNotification: function(notif) {
            notif.tracked = true;
            root.toastNotification = notif;
            root.toastVisible = true;
            toastTimer.restart();
        }
    }

    Timer {
        id: toastTimer
        interval: 5000
        onTriggered: root.toastVisible = false
    }

    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: bar
            required property var modelData
            screen: modelData
            anchors {
                top: true
                left: true
                right: true
            }
            color: "transparent"
            implicitHeight: 44

            property string dateText: ""
            property color barBgColor: "#80141418"
            property color barBorderColor: "#35ffffff"
            property color barTextColor: "#f5f7ff"
            property color buttonHoverColor: "#25ffffff"
            property color buttonActiveColor: "#40ffffff"
            property color buttonActiveBorderColor: "#55ffffff"
            property color tooltipBgColor: "#141418"

            property bool netConnected: false
            property bool hypridleEnabled: false

            property int volumePercent: 0
            property int micPercent: 0
            property int cpuPercent: 0
            property int ramPercent: 0
            property string ramUsedGB: ""
            property var workspaceSlots: bar.computeWorkspaceSlots(Hyprland.workspaces ? Hyprland.workspaces.values : [])

            function trimText(value) {
                if (value === undefined || value === null)
                    return "";
                return String(value).trim();
            }

            function volumeIcon(value) {
                if (value <= 0)
                    return "󰕿";
                if (value <= 25)
                    return "";
                if (value <= 50)
                    return "";
                if (value <= 75)
                    return "󰕾";
                return "";
            }

            function micIcon(value) {
                if (value <= 0)
                    return "󰍭";
                else
                    return "󰍬";
            }

            function updateDate() {
                dateText = Qt.formatDateTime(new Date(), "ddd MMM dd HH:mm:ss");
            }

            function computeWorkspaceSlots(workspaceValues) {
                var slots = [1, 2, 3, 4];
                if (!workspaceValues || !workspaceValues.length)
                    return slots;

                for (var i = 0; i < workspaceValues.length; i++) {
                    var workspace = workspaceValues[i];
                    if (!workspace || workspace.id === undefined || workspace.id === null)
                        continue;
                    var id = Number(workspace.id);
                    if (isNaN(id) || id <= 4)
                        continue;
                    if (slots.indexOf(id) === -1)
                        slots.push(id);
                }

                slots.sort(function (a, b) {
                    return a - b;
                });
                return slots;
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

                    bar.barBgColor = rgbaFromHex(background, 0.50);
                    bar.barBorderColor = rgbaFromHex(accent, 0.35);
                    bar.barTextColor = foreground;
                    bar.buttonHoverColor = rgbaFromHex(accent, 0.15);
                    bar.buttonActiveColor = rgbaFromHex(accent, 0.30);
                    bar.buttonActiveBorderColor = rgbaFromHex(accent, 0.55);
                    bar.tooltipBgColor = rgbaFromHex(background, 1.0);

                    root.notifBgColor = rgbaFromHex(background, 0.92);
                    root.notifBorderColor = rgbaFromHex(accent, 0.35);
                    root.notifTextColor = foreground;
                    root.notifSubTextColor = rgbaFromHex(foreground, 0.60);
                    root.notifAccentColor = rgbaFromHex(colors.color4 || accent, 0.60);
                    root.notifHoverColor = rgbaFromHex(accent, 0.15);
                    root.notifUrgentColor = colors.color1 || "#e05555";
                } catch (e) {}
            }

            Rectangle {
                id: capsule
                anchors {
                    fill: parent
                    leftMargin: 6
                    rightMargin: 6
                    topMargin: 5
                    bottomMargin: 5
                }
                radius: 4
                color: bar.barBgColor
                border.width: 1
                border.color: bar.barBorderColor

                Rectangle {
                    visible: root.notifPanelOpen
                    width: parent.radius
                    height: parent.radius
                    anchors.bottom: parent.bottom
                    anchors.right: parent.right
                    color: parent.color

                    Rectangle {
                        width: 1
                        height: parent.height
                        color: parent.parent.border.color
                        anchors.right: parent.right
                        anchors.bottom: parent.bottom
                    }
                    Rectangle {
                        width: parent.width
                        height: 1
                        color: parent.parent.border.color
                        anchors.bottom: parent.bottom
                        anchors.right: parent.right
                    }
                }

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 10
                    anchors.rightMargin: 10
                    spacing: 10

                    RowLayout {
                        id: leftSection
                        spacing: 4

                        BarButton {
                            iconText: ""
                            iconPixelSize: 20
                            labelText: ""
                            clickable: false
                        }

                        Repeater {
                            model: bar.workspaceSlots

                            BarButton {
                                required property int modelData
                                iconText: ""
                                labelText: String(modelData)
                                active: Hyprland.focusedWorkspace != null && modelData === Hyprland.focusedWorkspace.id
                                scale: active ? 1.08 : 1.0
                                implicitWidth: 24
                                implicitHeight: 24
                                radius: 6
                                onClicked: {
                                    Hyprland.dispatch("workspace " + modelData);
                                }
                            }
                        }
                    }

                    Item {
                        Layout.fillWidth: true
                    }

                    RowLayout {
                        id: rightSection
                        spacing: 4

                        StatButton {
                            id: ramBtn
                            iconText: "󰓅"
                            valueText: bar.ramPercent + "%"
                            clickable: false

                            ToolTip {
                                visible: ramBtn.hovered && bar.ramUsedGB.length > 0
                                delay: 400
                                leftPadding: 8
                                rightPadding: 8
                                topPadding: 5
                                bottomPadding: 5

                                background: Rectangle {
                                    color: bar.tooltipBgColor
                                    border.color: bar.barBorderColor
                                    border.width: 1
                                    radius: 6
                                }

                                contentItem: Text {
                                    text: bar.ramUsedGB + " GB"
                                    color: bar.barTextColor
                                    font.pixelSize: 12
                                    font.bold: true
                                }
                            }
                        }

                        StatButton {
                            iconText: "󰘚"
                            valueText: bar.cpuPercent + "%"
														onClicked: {
																htopProc.command = ["bash", "-lc", "WAYLAND_DISPLAY=1 wezterm start -- htop"]
																htopProc.running = true
														}
                        }

                        StatButton {
                            iconText: bar.micIcon(bar.micPercent)
                            valueText: bar.micPercent + "%"
                            onClicked: {
                                pavuProc.command = ["bash", "-lc", "pavucontrol"];
                                pavuProc.running = true;
                            }
                        }

                        StatButton {
                            iconText: bar.volumeIcon(bar.volumePercent)
                            valueText: bar.volumePercent + "%"
                            onClicked: {
                                pavuProc.command = ["bash", "-lc", "pavucontrol"];
                                pavuProc.running = true;
                            }
                        }

                        BarButton {
                            iconText: ""
                            iconPixelSize: 18
                            labelText: ""
                            onClicked: {
                                blueberryProc.command = ["bash", "-lc", "blueberry"];
                                blueberryProc.running = true;
                            }
                        }

                        BarButton {
                            iconText: bar.netConnected ? "󰈀" : "󰲜"
                            iconPixelSize: 18
                            labelText: ""
                            onClicked: {
                                nmProc.command = ["bash", "-lc", "nm-connection-editor"];
                                nmProc.running = true;
                            }
                        }

                        BarButton {
                            iconText: bar.hypridleEnabled ? "󰒲" : ""
                            labelText: ""
                            onClicked: {
                                toggleHypridleProc.command = ["bash", "-lc", "$HOME/.dotfiles/waybar/.config/waybar/scripts/toggle-idle.sh"];
                                toggleHypridleProc.running = true;
                                hypridleStateProc.running = true;
                            }
                        }

                        BarButton {
                            iconText: ""
                            labelText: bar.dateText
                            clickable: false
                        }

                        BarButton {
                            id: bellBtn
                            iconText: ""
                            labelText: notifServer.trackedNotifications.values.length > 0 ? String(notifServer.trackedNotifications.values.length) : ""
                            active: root.notifPanelOpen
                            onClicked: root.notifPanelOpen = !root.notifPanelOpen
                        }
                    }
                }
            }

            Process {
                id: netStatusProc
                command: ["bash", "-lc", "nmcli -t -f STATE g 2>/dev/null | head -n1"]
                stdout: StdioCollector {
                    id: netStatusOut
                }
                onExited: {
                    bar.netConnected = bar.trimText(netStatusOut.text) === "connected";
                }
            }

            Process {
                id: hypridleStateProc
                command: ["bash", "-lc", "pgrep -x hypridle >/dev/null && echo on || echo off"]
                stdout: StdioCollector {
                    id: hypridleStateOut
                }
                onExited: {
                    bar.hypridleEnabled = bar.trimText(hypridleStateOut.text) === "on";
                }
            }

            Process {
                id: volumeProc
                command: ["bash", "-lc", "pactl get-sink-volume @DEFAULT_SINK@ | grep -Eo '[0-9]+%' | head -n1 | tr -d '%' || echo 0"]
                stdout: StdioCollector {
                    id: volumeOut
                }
                onExited: {
                    var value = Number(bar.trimText(volumeOut.text));
                    if (!isNaN(value))
                        bar.volumePercent = value;
                }
            }

            Process {
                id: micProc
                command: ["bash", "-lc", "pactl get-source-volume @DEFAULT_SOURCE@ | grep -Eo '[0-9]+%' | head -n1 | tr -d '%' || echo 0"]
                stdout: StdioCollector {
                    id: micOut
                }
                onExited: {
                    var value = Number(bar.trimText(micOut.text));
                    if (!isNaN(value))
                        bar.micPercent = value;
                }
            }

            Process {
                id: cpuProc
                command: ["bash", "-lc", "top -bn1 | awk '/^%Cpu/ {print int($2+$4)}' || echo 0"]
                stdout: StdioCollector {
                    id: cpuOut
                }
                onExited: {
                    var value = Number(bar.trimText(cpuOut.text));
                    if (!isNaN(value))
                        bar.cpuPercent = value;
                }
            }

            Process {
                id: ramProc
                command: ["bash", "-lc", "free | awk '/Mem:/ {printf \"%d %.1f\", ($3/$2)*100, $3/1024/1024}' || echo 0 0"]
                stdout: StdioCollector {
                    id: ramOut
                }
                onExited: {
                    var parts = bar.trimText(ramOut.text).split(" ");
                    var value = Number(parts[0]);
                    if (!isNaN(value))
                        bar.ramPercent = value;
                    if (parts.length > 1)
                        bar.ramUsedGB = parts[1];
                }
            }

						Process {
								id: htopProc
						}
						Process {
                id: pavuProc
            }
            Process {
                id: blueberryProc
            }
            Process {
                id: nmProc
            }
            Process {
                id: toggleHypridleProc
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
                onExited: bar.applyWalColors(walColorsOut.text)
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
                onTriggered: bar.updateDate()
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
                bar.updateDate();
                Hyprland.refreshWorkspaces();
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
    }

    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: notifPanel
            required property var modelData
            screen: modelData
            visible: root.notifPanelOpen || notifScale.yScale > 0.001

						margins {
							top: -6
						}

            anchors {
                top: true
                bottom: true
                left: true
                right: true
            }

            color: "transparent"
            exclusiveZone: 0

            MouseArea {
                anchors.fill: parent
                onClicked: root.notifPanelOpen = false
            }

            Item {
                width: 380
                height: 960

                anchors {
                    top: parent.top
                    right: parent.right
                    topMargin: -10
                    rightMargin: 2
                }

                MouseArea {
                    anchors.fill: parent
                }

                Item {
                    id: notifContainer
                    anchors.fill: parent
                    anchors.margins: 4
                    clip: true

                    transform: Scale {
                        id: notifScale
                        origin.y: 0
                        origin.x: notifContainer.width / 2
                        yScale: root.notifPanelOpen ? 1.0 : 0.0

                        Behavior on yScale {
                            NumberAnimation {
                                duration: 250
                                easing.type: Easing.OutCubic
                            }
                        }
                    }

                Item {
                    anchors.fill: parent
                    clip: true

                    Rectangle {
                        anchors.fill: parent
                        anchors.topMargin: -10
                        radius: 4
                        color: root.notifBgColor
                        border.width: 1
                        border.color: root.notifBorderColor
                    }
                }

                Column {
                    anchors.fill: parent
                    anchors.margins: 10

                    RowLayout {
                        width: parent.width
                        height: 36

                        Text {
                            text: "  Notifications"
                            color: root.notifTextColor
                            font.family: root.fontFamily
                            font.pixelSize: 14
                            font.bold: true
                            Layout.fillWidth: true
                        }

                        Rectangle {
                            visible: notifServer.trackedNotifications.values.length > 0
                            Layout.preferredWidth: clearLabel.implicitWidth + 20
                            Layout.preferredHeight: 26
                            radius: 8
                            color: clearHover.containsMouse ? root.notifHoverColor : "transparent"

                            Text {
                                id: clearLabel
                                anchors.centerIn: parent
                                text: "Clear All"
                                color: root.notifSubTextColor
                                font.family: root.fontFamily
                                font.pixelSize: 12
                            }

                            MouseArea {
                                id: clearHover
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    var notifs = notifServer.trackedNotifications.values;
                                    for (var i = notifs.length - 1; i >= 0; i--)
                                        notifs[i].dismiss();
                                }
                            }
                        }
                    }

                    // Separator
                    Rectangle {
                        width: parent.width
                        height: 1
                        color: root.notifBorderColor
                    }

                    Item {
                        width: parent.width
                        height: parent.height - 45

                        Column {
                            anchors.centerIn: parent
                            visible: notifServer.trackedNotifications.values.length === 0
                            spacing: 8

                            Text {
                                text: "✨"
                                font.pixelSize: 28
                                anchors.horizontalCenter: parent.horizontalCenter
                            }

                            Text {
                                text: "All caught up!"
                                color: root.notifSubTextColor
                                font.family: root.fontFamily
                                font.pixelSize: 13
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                        }

                        ListView {
                            id: notifListView
                            anchors.fill: parent
                            anchors.topMargin: 6
                            model: notifServer.trackedNotifications
                            spacing: 6
                            clip: true

                            delegate: NotifItem {
                                required property var modelData
                                width: notifListView.width
                                notif: modelData
                            }
                        }
                    }
                }
            }
        }
    }
    }

    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: toastPanel
            required property var modelData
            screen: modelData
            visible: root.toastVisible && root.toastNotification !== null && !root.notifPanelOpen

            anchors {
                top: true
                right: true
            }

            color: "transparent"
            exclusiveZone: 0
            implicitWidth: 380
            implicitHeight: 90

            margins {
                top: 10
                right: 8
            }

            Rectangle {
                anchors.fill: parent
                anchors.margins: 4
                radius: 4
                color: root.notifBgColor
                border.width: 1
                border.color: root.notifBorderColor

                Rectangle {
                    width: 3
                    height: parent.height - 16
                    anchors.left: parent.left
                    anchors.leftMargin: 8
                    anchors.verticalCenter: parent.verticalCenter
                    radius: 2
                    color: root.notifAccentColor
                }

                Image {
                    id: toastIcon
                    anchors.left: parent.left
                    anchors.leftMargin: 18
                    anchors.verticalCenter: parent.verticalCenter
                    width: 48
                    height: 48
                    source: root.toastNotification ?
                        (root.toastNotification.image ? root.toastNotification.image :
                        (root.toastNotification.appIcon ? "image://icon/" + root.toastNotification.appIcon : "")) : ""
                    fillMode: Image.PreserveAspectFit
                    visible: source.toString().length > 0
                }

                Column {
                    anchors.fill: parent
                    anchors.leftMargin: toastIcon.visible ? 78 : 18
                    anchors.rightMargin: 40
                    anchors.topMargin: 12
                    anchors.bottomMargin: 12
                    spacing: 3

                    Text {
                        text: root.toastNotification ? (root.toastNotification.appName || "Notification") : ""
                        color: root.notifSubTextColor
                        font.family: root.fontFamily
                        font.pixelSize: 11
                        elide: Text.ElideRight
                        width: parent.width
                    }

                    Text {
                        text: root.toastNotification ? (root.toastNotification.summary || "") : ""
                        color: root.notifTextColor
                        font.family: root.fontFamily
                        font.pixelSize: 13
                        font.bold: true
                        elide: Text.ElideRight
                        width: parent.width
                    }

                    Text {
                        text: root.toastNotification ? (root.toastNotification.body || "") : ""
                        color: root.notifSubTextColor
                        font.family: root.fontFamily
                        font.pixelSize: 12
                        elide: Text.ElideRight
                        maximumLineCount: 2
                        wrapMode: Text.WordWrap
                        width: parent.width
                    }
                }

                Rectangle {
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.rightMargin: 8
                    anchors.topMargin: 8
                    width: 22
                    height: 22
                    radius: 11
                    color: toastCloseHover.containsMouse ? root.notifHoverColor : "transparent"

                    Text {
                        anchors.centerIn: parent
                        text: "✕"
                        color: root.notifSubTextColor
                        font.pixelSize: 12
                    }

                    MouseArea {
                        id: toastCloseHover
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.toastVisible = false
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    z: -1
                    onClicked: {
                        root.toastVisible = false;
                        root.notifPanelOpen = true;
                    }
                }
            }
        }
    }

    component NotifItem: Rectangle {
        id: notifItemRoot
        property var notif: null

        height: notifContent.implicitHeight + 20
        radius: 10
        color: notifItemHover.containsMouse ? root.notifHoverColor : "transparent"
        border.width: 1
        border.color: notifItemHover.containsMouse ? root.notifBorderColor : "transparent"

        Behavior on color {
            ColorAnimation { duration: 180 }
        }

        Rectangle {
            width: 3
            height: parent.height - 12
            anchors.left: parent.left
            anchors.leftMargin: 6
            anchors.verticalCenter: parent.verticalCenter
            radius: 2
            color: notifItemRoot.notif && notifItemRoot.notif.urgency === 2 ? root.notifUrgentColor : root.notifAccentColor
        }

        Image {
            id: notifIcon
            anchors.left: parent.left
            anchors.leftMargin: 16
            anchors.verticalCenter: parent.verticalCenter
            width: 42
            height: 42
            source: notifItemRoot.notif ?
                (notifItemRoot.notif.image ? notifItemRoot.notif.image :
                (notifItemRoot.notif.appIcon ? "image://icon/" + notifItemRoot.notif.appIcon : "")) : ""
            fillMode: Image.PreserveAspectFit
            visible: source.toString().length > 0
        }

        Column {
            id: notifContent
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: notifIcon.visible ? 70 : 16
            anchors.rightMargin: 34
            anchors.verticalCenter: parent.verticalCenter
            spacing: 2

            Text {
                text: notifItemRoot.notif ? (notifItemRoot.notif.appName || "Notification") : ""
                color: root.notifSubTextColor
                font.family: root.fontFamily
                font.pixelSize: 11
                elide: Text.ElideRight
                width: parent.width
            }

            Text {
                text: notifItemRoot.notif ? (notifItemRoot.notif.summary || "") : ""
                color: root.notifTextColor
                font.family: root.fontFamily
                font.pixelSize: 13
                font.bold: true
                elide: Text.ElideRight
                width: parent.width
            }

            Text {
                visible: notifItemRoot.notif ? (notifItemRoot.notif.body || "").length > 0 : false
                text: notifItemRoot.notif ? (notifItemRoot.notif.body || "") : ""
                color: root.notifSubTextColor
                font.family: root.fontFamily
                font.pixelSize: 12
                wrapMode: Text.WordWrap
                maximumLineCount: 3
                elide: Text.ElideRight
                width: parent.width
            }
        }

        Rectangle {
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.rightMargin: 6
            anchors.topMargin: 6
            width: 22
            height: 22
            radius: 11
            color: dismissHover.containsMouse ? root.notifHoverColor : "transparent"
            visible: notifItemHover.containsMouse

            Text {
                anchors.centerIn: parent
                text: "✕"
                color: root.notifSubTextColor
                font.pixelSize: 11
            }

            MouseArea {
                id: dismissHover
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    if (notifItemRoot.notif)
                        notifItemRoot.notif.dismiss();
                }
            }
        }

        MouseArea {
            id: notifItemHover
            anchors.fill: parent
            hoverEnabled: true
            z: -1
        }
    }

    component BarButton: Rectangle {
        id: btn
        property string iconText: ""
        property string labelText: ""
        property int iconPixelSize: 14
        property int labelPixelSize: 13
        property bool clickable: true
        property bool active: false
        readonly property bool hovered: hover.containsMouse
        signal clicked

        radius: 8
        color: active ? bar.buttonActiveColor : hover.containsMouse ? bar.buttonHoverColor : "transparent"
        border.width: active ? 1 : 0
        border.color: bar.buttonActiveBorderColor
        implicitHeight: 28
        implicitWidth: content.implicitWidth + 14

        Behavior on color {
            ColorAnimation {
                duration: 220
                easing.type: Easing.InOutCubic
            }
        }

        Behavior on border.width {
            NumberAnimation {
                duration: 180
                easing.type: Easing.OutCubic
            }
        }

        Behavior on scale {
            NumberAnimation {
                duration: 220
                easing.type: Easing.OutCubic
            }
        }

        Row {
            id: content
            anchors.centerIn: parent
            spacing: iconText.length > 0 && labelText.length > 0 ? 5 : 0

            Text {
                visible: iconText.length > 0
                text: iconText
                color: bar.barTextColor
                font.family: root.fontFamily
                font.pixelSize: iconPixelSize
                font.bold: true
            }

            Text {
                visible: labelText.length > 0
                text: labelText
                color: bar.barTextColor
                font.family: root.fontFamily
                font.pixelSize: labelPixelSize
                font.bold: true
            }
        }

        MouseArea {
            id: hover
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: btn.clickable ? Qt.PointingHandCursor : Qt.ArrowCursor
            onClicked: if (btn.clickable) btn.clicked()
        }
    }

    component StatButton: BarButton {
        property string valueText: ""
        labelText: valueText
    }
}
