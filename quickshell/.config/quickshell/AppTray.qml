pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Services.SystemTray

RowLayout {
    id: trayRoot
    required property var panelWindow
    spacing: 6

    property var currentMenu: null
    property var currentMenuItem: null
    property point menuPos: Qt.point(0, 0)

    function resolvedWindow() {
        if (!trayRoot.panelWindow)
            return null;
        if (trayRoot.panelWindow.window)
            return trayRoot.panelWindow.window;
        return trayRoot.panelWindow;
    }

    function openStyledMenu(menu, menuItem, menuX, menuY) {
        if (trayMenuWindow.visible && trayRoot.currentMenu === menu) {
            trayRoot.closeStyledMenu();
            return;
        }

        trayRoot.currentMenu = menu;
        trayRoot.currentMenuItem = menuItem;
        trayRoot.menuPos = Qt.point(menuX, menuY);
        trayDismissWindow.visible = true;
        trayMenuWindow.visible = true;
    }

    function closeStyledMenu() {
        trayDismissWindow.visible = false;
        trayMenuWindow.visible = false;
        trayRoot.currentMenu = null;
        trayRoot.currentMenuItem = null;
    }

    QsMenuOpener {
        id: menuOpener
        menu: trayRoot.currentMenu
    }

    PopupWindow {
        id: trayDismissWindow
        visible: false
        color: "transparent"
        implicitWidth: trayRoot.panelWindow?.screen ? trayRoot.panelWindow.screen.width : 1
        implicitHeight: trayRoot.panelWindow?.screen ? trayRoot.panelWindow.screen.height : 1

        anchor {
            window: trayRoot.panelWindow
            rect.x: 0
            rect.y: 0
        }

        mask: Region {
            item: dismissHole
            intersection: Intersection.Xor
        }

        Item {
            id: dismissHole
            x: trayRoot.menuPos.x
            y: trayRoot.menuPos.y
            width: trayMenuWindow.implicitWidth
            height: trayMenuWindow.implicitHeight
        }

        MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
            onPressed: mouse => {
                mouse.accepted = true;
                trayRoot.closeStyledMenu();
            }
        }
    }

    PopupWindow {
        id: trayMenuWindow
        visible: false
        color: "transparent"
        implicitWidth: 252
        implicitHeight: menuContent.implicitHeight + 2

        Keys.onEscapePressed: trayRoot.closeStyledMenu()

        anchor {
            window: trayRoot.panelWindow
            rect.x: trayRoot.menuPos.x
            rect.y: trayRoot.menuPos.y
        }

        Rectangle {
            id: menuBg
            anchors.fill: parent
            color: AppState.tooltipBgColor
            border.color: AppState.barBorderColor
            border.width: 1
            radius: 8

            Column {
                id: menuContent
                anchors.fill: parent
                topPadding: 4
                bottomPadding: 4

                Repeater {
                    model: menuOpener.children

                    delegate: Item {
                        id: menuRow
                        required property var modelData

                        implicitWidth: 250
                        implicitHeight: modelData.isSeparator ? 8 : 30

                        Rectangle {
                            visible: menuRow.modelData.isSeparator
                            anchors {
                                left: parent.left
                                right: parent.right
                                verticalCenter: parent.verticalCenter
                                leftMargin: 10
                                rightMargin: 10
                            }
                            height: 1
                            color: AppState.barBorderColor
                        }

                        Rectangle {
                            visible: !menuRow.modelData.isSeparator
                            anchors.fill: parent
                            color: rowMouse.containsMouse && menuRow.modelData.enabled ? Qt.rgba(AppState.barBorderColor.r, AppState.barBorderColor.g, AppState.barBorderColor.b, 0.25) : "transparent"
                            radius: 6

                            RowLayout {
                                anchors.fill: parent
                                anchors.leftMargin: 10
                                anchors.rightMargin: 10
                                spacing: 8

                                Text {
                                    Layout.preferredWidth: 14
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                    color: menuRow.modelData.enabled ? AppState.barTextColor : Qt.rgba(AppState.barTextColor.r, AppState.barTextColor.g, AppState.barTextColor.b, 0.45)
                                    text: {
                                        if (menuRow.modelData.buttonType === QsMenuButtonType.CheckBox)
                                            return menuRow.modelData.checkState === Qt.Checked ? "✓" : "";
                                        if (menuRow.modelData.buttonType === QsMenuButtonType.RadioButton)
                                            return menuRow.modelData.checkState === Qt.Checked ? "●" : "○";
                                        return "";
                                    }
                                    font.pixelSize: 13
                                    font.bold: true
                                }

                                Image {
                                    Layout.preferredWidth: 16
                                    Layout.preferredHeight: 16
                                    visible: menuRow.modelData.icon !== ""
                                    source: menuRow.modelData.icon
                                    sourceSize: Qt.size(16, 16)
                                    fillMode: Image.PreserveAspectFit
                                    smooth: true
                                    mipmap: true
                                }

                                Text {
                                    Layout.fillWidth: true
                                    text: menuRow.modelData.text
                                    color: menuRow.modelData.enabled ? AppState.barTextColor : Qt.rgba(AppState.barTextColor.r, AppState.barTextColor.g, AppState.barTextColor.b, 0.45)
                                    font.pixelSize: 13
                                    font.bold: true
                                    elide: Text.ElideRight
                                    verticalAlignment: Text.AlignVCenter
                                }

                                Text {
                                    visible: menuRow.modelData.hasChildren
                                    text: "▶"
                                    color: menuRow.modelData.enabled ? AppState.barTextColor : Qt.rgba(AppState.barTextColor.r, AppState.barTextColor.g, AppState.barTextColor.b, 0.45)
                                    font.pixelSize: 11
                                    font.bold: true
                                    verticalAlignment: Text.AlignVCenter
                                }
                            }

                            MouseArea {
                                id: rowMouse
                                anchors.fill: parent
                                hoverEnabled: true
                                enabled: menuRow.modelData.enabled
                                onClicked: mouse => {
                                    if (menuRow.modelData.hasChildren) {
                                        const window = trayMenuWindow;
                                        if (!window || !window.contentItem)
                                            return;
                                        const pos = menuRow.mapToItem(window.contentItem, mouse.x + menuRow.width, mouse.y);
                                        menuRow.modelData.display(window, pos.x, pos.y);
                                    } else {
                                        menuRow.modelData.triggered();
                                        trayRoot.closeStyledMenu();
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        onVisibleChanged: if (!visible) {
            trayRoot.currentMenu = null;
            trayRoot.currentMenuItem = null;
        }
    }

    Repeater {
        model: SystemTray.items

        Item {
            id: trayItem
            required property var modelData
            implicitWidth: 24
            implicitHeight: 24

            function windowPosition(localX, localY) {
                const window = trayRoot.resolvedWindow();
                if (!window || !window.contentItem)
                    return Qt.point(localX, localY);
                return mapToItem(window.contentItem, localX, localY);
            }

            function openMenuAt(localX, localY) {
                if (!trayItem.modelData.hasMenu)
                    return;

                const pos = windowPosition(localX, localY);
                trayRoot.openStyledMenu(trayItem.modelData.menu, trayItem.modelData, pos.x, pos.y);
            }

            Image {
                anchors.centerIn: parent
                width: 16
                height: 16
                source: trayItem.modelData.icon || ""
                sourceSize: Qt.size(16, 16)
            }

            MouseArea {
                id: mouseArea
                anchors.fill: parent
                hoverEnabled: true
                acceptedButtons: Qt.LeftButton | Qt.RightButton

                onClicked: mouse => {
                    if (mouse.button === Qt.LeftButton) {
                        if (trayItem.modelData.onlyMenu && trayItem.modelData.hasMenu) {
                            parent.openMenuAt(mouse.x, mouse.y);
                        } else {
                            trayItem.modelData.activate();
                        }
                    } else if (mouse.button === Qt.RightButton) {
                        if (trayItem.modelData.hasMenu) {
                            parent.openMenuAt(mouse.x, mouse.y);
                        } else {
                            trayItem.modelData.secondaryActivate();
                        }
                    }
                }
            }

            ToolTip {
                id: trayTooltip
                visible: mouseArea.containsMouse && (trayItem.modelData.title.length > 0 || trayItem.modelData.tooltipTitle.length > 0)
                text: trayItem.modelData.tooltipTitle || trayItem.modelData.title
                delay: 1000

                background: Rectangle {
                    color: AppState.tooltipBgColor
                    border.color: AppState.barBorderColor
                    border.width: 1
                    radius: 6
                }
                contentItem: Text {
                    text: trayTooltip.text
                    color: AppState.barTextColor
                    font.pixelSize: 12
                    font.bold: true
                }
            }
        }
    }
}
