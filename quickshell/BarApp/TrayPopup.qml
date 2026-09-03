import Quickshell
import Quickshell.Wayland
import Quickshell.Services.SystemTray
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import "../CustomTheme"

PanelWindow {
    id: popup
    property bool active: false
    property var barWindow

    property int iconSize: 22
    property int itemSize: 36
    property int itemSpacing: 6

    property bool showPassive: false
    property int maxIcons: 4

    visible: active

    anchors { top: true; bottom: true; left: true; right: true }
    WlrLayershell.layer: WlrLayer.Overlay
    exclusionMode: WlrLayershell.Ignore
    WlrLayershell.keyboardFocus: WlrLayershell.OnDemand
    color: "transparent"

    MouseArea {
        anchors.fill: parent
        onClicked: popup.active = false
    }

    Rectangle {
        id: pill
        property int cols: Math.min(Math.ceil(trayRepeater.count / 4), 3)
        width: Math.min(trayFlow.implicitWidth + 20, 380)
        height: Math.min(trayFlow.implicitHeight + 16, 340)

        anchors.right: parent.right
        anchors.rightMargin: 14
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: -48

        radius: 16
        color: Theme.background
        border.color: Theme.primary
        border.width: 1.5
        opacity: 0.92

        Flow {
            id: trayFlow
            anchors.fill: parent
            anchors.margins: 10
            spacing: popup.itemSpacing

            Repeater {
                id: trayRepeater
                model: SystemTray.items.values

                delegate: Item {
                    id: trayItem
                    required property var modelData
                    required property int index

                    width: shouldShowOverflow(modelData, index) ? popup.itemSize : 0
                    height: shouldShowOverflow(modelData, index) ? popup.itemSize : 0
                    visible: shouldShowOverflow(modelData, index)
                    clip: true

                    Rectangle {
                        anchors.fill: parent
                        radius: 9
                        color: mouseArea.containsMouse
                            ? Qt.rgba(Theme.primary.r, Theme.primary.g, Theme.primary.b, 0.15)
                            : "transparent"
                    }

                    IconImage {
                        anchors.centerIn: parent
                        implicitSize: popup.iconSize
                        source: trayItem.modelData.icon
                        asynchronous: true
                        mipmap: true
                    }

                    MouseArea {
                        id: mouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton

                        onClicked: function(mouse) {
                            if (mouse.button === Qt.LeftButton) {
                                if (trayItem.modelData.onlyMenu && trayItem.modelData.hasMenu) {
                                    openTrayMenu()
                                } else {
                                    trayItem.modelData.activate()
                                }
                            } else if (mouse.button === Qt.RightButton) {
                                openTrayMenu()
                            } else if (mouse.button === Qt.MiddleButton) {
                                trayItem.modelData.secondaryActivate()
                            }
                            popup.active = false
                        }

                        onWheel: function(wheel) {
                            trayItem.modelData.scroll(wheel.angleDelta.y, false)
                        }
                    }

                    function openTrayMenu() {
                        if (!trayItem.modelData.hasMenu)
                            return
                        var p = trayItem.mapToItem(null, trayItem.width / 2, trayItem.height + 4)
                        trayItem.modelData.display(
                            popup.barWindow,
                            Math.round(p.x),
                            Math.round(p.y)
                        )
                    }
                }
            }

            Text {
                visible: overflowCountPopup() === 0
                text: "No hidden icons"
                color: Theme.primary
                opacity: 0.4
                font.family: "Maple Mono NF CN"
                font.pixelSize: 11
                width: parent.width
                horizontalAlignment: Text.AlignHCenter
            }
        }
    }

    function itemAllowed(item) {
        if (!item) return false
        if (!popup.showPassive && item.status === Status.Passive) return false
        return true
    }

    function visibleIndex(item, rawIndex) {
        var n = 0
        var items = SystemTray.items.values
        for (var i = 0; i < rawIndex; ++i) {
            if (itemAllowed(items[i])) n++
        }
        return n
    }

    function shouldShowInBar(item, rawIndex) {
        if (!itemAllowed(item)) return false
        return visibleIndex(item, rawIndex) < popup.maxIcons
    }

    function shouldShowOverflow(item, rawIndex) {
        if (!itemAllowed(item)) return false
        return visibleIndex(item, rawIndex) >= popup.maxIcons
    }

    function overflowCountPopup() {
        var n = 0
        var items = SystemTray.items.values
        for (var i = 0; i < items.length; ++i) {
            if (itemAllowed(items[i])) n++
        }
        return Math.max(n - popup.maxIcons, 0)
    }
}
