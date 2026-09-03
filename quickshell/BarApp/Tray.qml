import Quickshell
import Quickshell.Services.SystemTray
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import "../CustomTheme"

Item {
    id: root

    property var barWindow
    property var trayPopup
    property int iconSize: 16
    property int itemSize: 22
    property int itemSpacing: 4

    // 少占位置：默认隐藏 Passive 图标
    property bool showPassive: false

    // 最多显示几个托盘图标，防止 Telegram、Steam、Clash、蓝牙一堆挤爆
    property int maxIcons: 4

    visible: visibleCount() > 0
    width: visible ? trayRow.implicitWidth : 0
    height: itemSize

    Row {
        id: trayRow
        anchors.centerIn: parent
        spacing: root.itemSpacing

        Repeater {
            model: SystemTray.items.values

            delegate: Item {
                id: trayButton

                required property var modelData
                required property int index

                width: shouldShow(modelData, index) ? root.itemSize : 0
                height: root.itemSize
                visible: shouldShow(modelData, index)
                clip: true

                Rectangle {
                    anchors.fill: parent
                    radius: 7
                    color: mouseArea.containsMouse ? Theme.background : "transparent"
                    opacity: mouseArea.containsMouse ? 0.9 : 1.0
                }

                IconImage {
                    anchors.centerIn: parent
                    implicitSize: root.iconSize
                    source: trayButton.modelData.icon
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
                            if (trayButton.modelData.onlyMenu && trayButton.modelData.hasMenu) {
                                openTrayMenu()
                            } else {
                                trayButton.modelData.activate()
                            }
                        } else if (mouse.button === Qt.RightButton) {
                            openTrayMenu()
                        } else if (mouse.button === Qt.MiddleButton) {
                            trayButton.modelData.secondaryActivate()
                        }
                    }

                    onWheel: function(wheel) {
                        trayButton.modelData.scroll(wheel.angleDelta.y, false)
                    }
                }

                function openTrayMenu() {
                    if (!trayButton.modelData.hasMenu)
                        return

                    // mapToItem(null, ...) 得到相对当前窗口内容区的坐标
                    var p = trayButton.mapToItem(null, trayButton.width / 2, trayButton.height + 4)

                    // 比 QsMenuAnchor 更直接，很多托盘程序右键菜单用这个更稳
                    trayButton.modelData.display(
                        root.barWindow,
                        Math.round(p.x),
                        Math.round(p.y)
                    )
                }
            }
        }

        Rectangle {
            visible: overflowCount() > 0
            width: overflowText.implicitWidth + 10
            height: 20
            radius: 6
            color: overflowMouse.containsMouse
                ? Qt.rgba(Theme.primary.r, Theme.primary.g, Theme.primary.b, 0.15)
                : "transparent"
            anchors.verticalCenter: parent.verticalCenter

            Text {
                id: overflowText
                anchors.centerIn: parent
                text: "+" + overflowCount()
                color: Theme.primary
                font.family: "Maple Mono NF CN"
                font.pixelSize: 10
                font.weight: Font.Bold
            }

            MouseArea {
                id: overflowMouse
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    if (root.trayPopup) {
                        root.trayPopup.active = !root.trayPopup.active
                    }
                }
            }
        }
    }

    function itemAllowed(item) {
        if (!item)
            return false

        if (!root.showPassive && item.status === Status.Passive)
            return false

        return true
    }

    function visibleIndex(item, rawIndex) {
        var n = 0
        var items = SystemTray.items.values

        for (var i = 0; i < rawIndex; ++i) {
            if (itemAllowed(items[i]))
                n++
        }

        return n
    }

    function shouldShow(item, rawIndex) {
        if (!itemAllowed(item))
            return false

        return visibleIndex(item, rawIndex) < root.maxIcons
    }

    function visibleCount() {
        var n = 0
        var items = SystemTray.items.values

        for (var i = 0; i < items.length; ++i) {
            if (itemAllowed(items[i]))
                n++
        }

        return Math.min(n, root.maxIcons)
    }

    function overflowCount() {
        var n = 0
        var items = SystemTray.items.values

        for (var i = 0; i < items.length; ++i) {
            if (itemAllowed(items[i]))
                n++
        }

        return Math.max(n - root.maxIcons, 0)
    }
}
