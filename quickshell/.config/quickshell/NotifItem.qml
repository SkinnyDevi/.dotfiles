import QtQuick
import "."

Rectangle {
    id: notifItemRoot
    property var notif: null

    height: notifContent.implicitHeight + 20
    radius: 10
    color: notifItemHover.containsMouse ? AppState.notifHoverColor : "transparent"
    border.width: 1
    border.color: notifItemHover.containsMouse ? AppState.notifBorderColor : "transparent"

    Behavior on color {
        ColorAnimation {
            duration: 180
        }
    }

    Rectangle {
        width: 3
        height: parent.height - 12
        anchors.left: parent.left
        anchors.leftMargin: 6
        anchors.verticalCenter: parent.verticalCenter
        radius: 2
        color: notifItemRoot.notif && notifItemRoot.notif.urgency === 2 ? AppState.notifUrgentColor : AppState.notifAccentColor
    }

    Image {
        id: notifIcon
        anchors.left: parent.left
        anchors.leftMargin: 16
        anchors.verticalCenter: parent.verticalCenter
        width: 42
        height: 42
        source: notifItemRoot.notif ? (notifItemRoot.notif.image ? notifItemRoot.notif.image : (notifItemRoot.notif.appIcon ? "image://icon/" + notifItemRoot.notif.appIcon : "")) : ""
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

        function notifDateText(notification) {
            if (!notification)
                return "";
            var timestamp = notification.receivedAt;
            if (timestamp === undefined || timestamp === null)
                timestamp = Date.now();
            return Qt.formatDateTime(new Date(timestamp), "dd/MM hh:mm");
        }

        Text {
            text: notifItemRoot.notif ? notifContent.notifDateText(notifItemRoot.notif) : ""
            color: AppState.notifSubTextColor
            font.family: AppState.fontFamily
            font.pixelSize: 11
            elide: Text.ElideRight
            width: parent.width
        }

        Text {
            text: notifItemRoot.notif ? (notifItemRoot.notif.summary || "") : ""
            color: AppState.notifTextColor
            font.family: AppState.fontFamily
            font.pixelSize: 13
            font.bold: true
            elide: Text.ElideRight
            width: parent.width
        }

        Text {
            visible: notifItemRoot.notif ? (notifItemRoot.notif.body || "").length > 0 : false
            text: notifItemRoot.notif ? (notifItemRoot.notif.body || "") : ""
            color: AppState.notifSubTextColor
            font.family: AppState.fontFamily
            font.pixelSize: 12
            wrapMode: Text.Wrap
            maximumLineCount: 3
            elide: Text.ElideRight
            width: parent.width
            clip: true
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
        color: dismissHover.containsMouse ? AppState.notifHoverColor : "transparent"
        visible: notifItemHover.containsMouse

        Text {
            anchors.centerIn: parent
            text: "✕"
            color: AppState.notifSubTextColor
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
