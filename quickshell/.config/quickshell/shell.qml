//@ pragma UseQApplication

import QtQuick
import Quickshell

ShellRoot {
    id: root

    Variants {
        model: Quickshell.screens

        TopBar {}
    }

    Variants {
        model: Quickshell.screens

        NotificationCenter {}
    }

    Variants {
        model: Quickshell.screens

        ToastPanel {}
    }
}
