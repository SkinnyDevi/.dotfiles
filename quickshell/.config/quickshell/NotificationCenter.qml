import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland

PanelWindow {
    id: notifPanel
    required property var modelData
    screen: modelData
    visible: (AppState.notifPanelOpen || notifScale.yScale > 0.001) && Hyprland.focusedMonitor != null && modelData.name === Hyprland.focusedMonitor.name

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
        onClicked: AppState.notifPanelOpen = false
    }

    Item {
        id: notifContainer
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
            anchors.fill: parent
            anchors.margins: 4
            clip: true

            transform: Scale {
                id: notifScale
                origin.y: 0
                origin.x: notifContainer.width / 2
                yScale: AppState.notifPanelOpen ? 1.0 : 0.0

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
                    color: AppState.notifBgColor
                    border.width: 1
                    border.color: AppState.notifBorderColor
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
                        color: AppState.notifTextColor
                        font.family: AppState.fontFamily
                        font.pixelSize: 14
                        font.bold: true
                        Layout.fillWidth: true
                    }

                    Rectangle {
                        visible: NotificationService.trackedNotifications.values.length > 0
                        Layout.preferredWidth: clearLabel.implicitWidth + 20
                        Layout.preferredHeight: 26
                        radius: 8
                        color: clearHover.containsMouse ? AppState.notifHoverColor : "transparent"

                        Text {
                            id: clearLabel
                            anchors.centerIn: parent
                            text: "Clear All"
                            color: AppState.notifSubTextColor
                            font.family: AppState.fontFamily
                            font.pixelSize: 12
                        }

                        MouseArea {
                            id: clearHover
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                var notifs = NotificationService.trackedNotifications.values;
                                for (var i = notifs.length - 1; i >= 0; i--)
                                    notifs[i].dismiss();
                            }
                        }
                    }
                }

                Rectangle {
                    width: parent.width
                    height: 1
                    color: AppState.notifBorderColor
                }

                Item {
                    width: parent.width
                    height: parent.height - 45

                    Column {
                        anchors.centerIn: parent
                        visible: NotificationService.trackedNotifications.values.length === 0
                        spacing: 8

                        Text {
                            text: "✨"
                            font.pixelSize: 28
                            anchors.horizontalCenter: parent.horizontalCenter
                        }

                        Text {
                            text: "All caught up!"
                            color: AppState.notifSubTextColor
                            font.family: AppState.fontFamily
                            font.pixelSize: 13
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    ListView {
                        id: notifListView
                        anchors.fill: parent
                        anchors.topMargin: 6
                        model: NotificationService.trackedNotifications.values.slice().reverse()
                        spacing: 6
                        clip: true

                        delegate: NotifItem {
                            required property var modelData
                            width: parent.width
                            notif: modelData
                        }
                    }
                }
            }
        }
    }
}
