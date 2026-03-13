import QtQuick
import Quickshell
import Quickshell.Hyprland

PanelWindow {
    id: toastPanel
    required property var modelData
    screen: modelData

    property real offsetX: AppState.toastVisible ? 0 : 400
    Behavior on offsetX {
        NumberAnimation {
            duration: 300
            easing.type: Easing.OutCubic
        }
    }

    function adaptBodyText(bodyText) {
        if (bodyText.length < 35)
            return bodyText;
        return bodyText.substring(0, 35).trim() + "...";
    }

    visible: (AppState.toastVisible || offsetX < 390) && AppState.toastNotification !== null && !AppState.notifPanelOpen && Hyprland.focusedMonitor != null && modelData.name === Hyprland.focusedMonitor.name

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
        right: 8 - offsetX
    }

    Rectangle {
        anchors.fill: parent
        anchors.margins: 4
        radius: 4
        color: AppState.notifBgColor
        border.width: 1
        border.color: AppState.notifBorderColor

        Rectangle {
            width: 3
            height: parent.height - 16
            anchors.left: parent.left
            anchors.leftMargin: 8
            anchors.verticalCenter: parent.verticalCenter
            radius: 2
            color: AppState.notifAccentColor
        }

        Image {
            id: toastIcon
            anchors.left: parent.left
            anchors.leftMargin: 18
            anchors.verticalCenter: parent.verticalCenter
            width: 48
            height: 48
            source: AppState.toastNotification ? (AppState.toastNotification.image ? AppState.toastNotification.image : (AppState.toastNotification.appIcon ? "image://icon/" + AppState.toastNotification.appIcon : "")) : ""
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
                text: AppState.toastNotification ? Qt.formatDateTime(new Date(), "dd/MM hh:mm") : ""
                color: AppState.notifSubTextColor
                font.family: AppState.fontFamily
                font.pixelSize: 11
                elide: Text.ElideRight
                width: parent.width
            }

            Text {
                text: AppState.toastNotification ? (AppState.toastNotification.summary || "") : ""
                color: AppState.notifTextColor
                font.family: AppState.fontFamily
                font.pixelSize: 13
                font.bold: true
                elide: Text.ElideRight
                width: parent.width
            }

            Text {
                text: AppState.toastNotification ? (toastPanel.adaptBodyText(AppState.toastNotification.body) || "") : ""
                color: AppState.notifSubTextColor
                font.family: AppState.fontFamily
                font.pixelSize: 12
                elide: Text.ElideRight
                maximumLineCount: 2
                wrapMode: Text.Wrap
                width: parent.width
                clip: true
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
            color: toastCloseHover.containsMouse ? AppState.notifHoverColor : "transparent"

            Text {
                anchors.centerIn: parent
                text: "✕"
                color: AppState.notifSubTextColor
                font.pixelSize: 12
            }

            MouseArea {
                id: toastCloseHover
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: AppState.toastVisible = false
            }
        }

        MouseArea {
            anchors.fill: parent
            z: -1
            onClicked: {
                AppState.toastVisible = false;
                AppState.notifPanelOpen = true;
            }
        }
    }
}
