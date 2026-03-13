import QtQuick

Rectangle {
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
    color: active ? AppState.buttonActiveColor : hover.containsMouse ? AppState.buttonHoverColor : "transparent"
    border.width: active ? 1 : 0
    border.color: AppState.buttonActiveBorderColor
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
        spacing: btn.iconText.length > 0 && btn.labelText.length > 0 ? 5 : 0

        Text {
            visible: btn.iconText.length > 0
            text: btn.iconText
            color: AppState.barTextColor
            font.family: AppState.fontFamily
            font.pixelSize: btn.iconPixelSize
            font.bold: true
        }

        Text {
            visible: btn.labelText.length > 0
            text: btn.labelText
            color: AppState.barTextColor
            font.family: AppState.fontFamily
            font.pixelSize: btn.labelPixelSize
            font.bold: true
        }
    }

    MouseArea {
        id: hover
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: btn.clickable ? Qt.PointingHandCursor : Qt.ArrowCursor
        onClicked: if (btn.clickable)
            btn.clicked()
    }
}
