pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Services.Notifications

Singleton {
    id: root

    property alias trackedNotifications: notifServer.trackedNotifications

    NotificationServer {
        id: notifServer
        actionsSupported: true
        imageSupported: true
        keepOnReload: true
        onNotification: function (notif) {
            notif.tracked = true;
            notif.receivedAt = Date.now();
            AppState.toastNotification = notif;
            AppState.toastVisible = true;
            toastTimer.restart();
        }
    }

    Timer {
        id: toastTimer
        interval: 5000
        onTriggered: AppState.toastVisible = false
    }
}
