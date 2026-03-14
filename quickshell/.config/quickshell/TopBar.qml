import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import "."

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

    property var workspaceSlots: bar.computeWorkspaceSlots(Hyprland.workspaces ? Hyprland.workspaces.values : [])

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
        return value <= 0 ? "󰍭" : "󰍬";
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
        color: AppState.barBgColor
        border.width: 1
        border.color: AppState.barBorderColor

        Rectangle {
            visible: AppState.notifPanelOpen
            width: parent.radius
            height: parent.radius
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            color: parent.color

            Rectangle {
                width: 1
                height: parent.height
                color: capsule.border.color
                anchors.right: parent.right
                anchors.bottom: parent.bottom
            }
            Rectangle {
                width: parent.width
                height: 1
                color: capsule.border.color
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
                        onClicked: Hyprland.dispatch("workspace " + modelData)
                    }
                }
            }

            // Separator between Workspaces and AppTray
            Rectangle {
                width: 1
                height: 20
                color: AppState.barBorderColor
                Layout.alignment: Qt.AlignVCenter
            }

            AppTray {
                panelWindow: bar
            }

            Item {
                Layout.fillWidth: true
            }

            RowLayout {
                spacing: 4

                StatButton {
                    id: ramBtn
                    iconText: "󰓅"
                    valueText: SystemMetrics.ramPercent + "%"
                    clickable: false

                    ToolTip {
                        visible: ramBtn.hovered && SystemMetrics.ramUsedGB.length > 0
                        delay: 400
                        leftPadding: 8
                        rightPadding: 8
                        topPadding: 5
                        bottomPadding: 5
                        background: Rectangle {
                            color: AppState.tooltipBgColor
                            border.color: AppState.barBorderColor
                            border.width: 1
                            radius: 6
                        }
                        contentItem: Text {
                            text: SystemMetrics.ramUsedGB + " GB"
                            color: AppState.barTextColor
                            font.pixelSize: 12
                            font.bold: true
                        }
                    }
                }

                StatButton {
                    iconText: "󰘚"
                    valueText: SystemMetrics.cpuPercent + "%"
                    onClicked: {
                        htopProc.command = ["bash", "-lc", "WAYLAND_DISPLAY=1 wezterm start -- htop"];
                        htopProc.running = true;
                    }
                }

                StatButton {
                    iconText: bar.micIcon(SystemMetrics.micPercent)
                    valueText: SystemMetrics.micPercent + "%"
                    onClicked: {
                        pavuProc.command = ["bash", "-lc", "pavucontrol"];
                        pavuProc.running = true;
                    }
                }

                StatButton {
                    iconText: bar.volumeIcon(SystemMetrics.volumePercent)
                    valueText: SystemMetrics.volumePercent + "%"
                    onClicked: {
                        pavuProc.command = ["bash", "-lc", "pavucontrol"];
                        pavuProc.running = true;
                    }
                }

                BarButton {
                    iconText: "󰂯"
                    iconPixelSize: 18
                    labelText: ""
                    onClicked: {
                        blueberryProc.command = ["bash", "-lc", "blueberry"];
                        blueberryProc.running = true;
                    }
                }

                BarButton {
                    iconText: SystemMetrics.netConnected ? "󰈀" : "󰲜"
                    iconPixelSize: 18
                    labelText: ""
                    onClicked: {
                        nmProc.command = ["bash", "-lc", "nm-connection-editor"];
                        nmProc.running = true;
                    }
                }

                BarButton {
                    iconText: SystemMetrics.hypridleEnabled ? "󰒲" : ""
                    labelText: ""
                    onClicked: {
                        toggleHypridleProc.command = ["bash", "-lc", "$HOME/.dotfiles/waybar/.config/waybar/scripts/toggle-idle.sh"];
                        toggleHypridleProc.running = true;
                        SystemMetrics.pollHypridle();
                    }
                }

                BarButton {
                    iconText: ""
                    labelText: AppState.dateText
                    clickable: false
                }

                BarButton {
                    iconText: "󰂚"
                    labelText: NotificationService.trackedNotifications.values.length > 0 ? String(NotificationService.trackedNotifications.values.length) : ""
                    active: AppState.notifPanelOpen
                    onClicked: AppState.notifPanelOpen = !AppState.notifPanelOpen
                }
            }
        }
    }

    // App-launcher processes (on-demand, triggered by button clicks)
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

    Component.onCompleted: {
        AppState.updateDate();
        Hyprland.refreshWorkspaces();
    }
}
