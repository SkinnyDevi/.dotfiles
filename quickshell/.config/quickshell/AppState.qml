pragma Singleton

import QtQuick
import Quickshell

Singleton {
    id: root

    property string fontFamily: "SpaceMono Nerd Font"

    property bool notifPanelOpen: false
    property var toastNotification: null
    property bool toastVisible: false
    property string dateText: ""

    // Bar colors (updated by pywal via SystemMetrics)
    property color barBgColor: "#80141418"
    property color barBorderColor: "#35ffffff"
    property color barTextColor: "#f5f7ff"
    property color buttonHoverColor: "#25ffffff"
    property color buttonActiveColor: "#40ffffff"
    property color buttonActiveBorderColor: "#55ffffff"
    property color tooltipBgColor: "#141418"

    // Notification colors (updated by pywal via SystemMetrics)
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

    function updateDate() {
        dateText = Qt.formatDateTime(new Date(), "ddd MMM dd HH:mm:ss");
    }
}
