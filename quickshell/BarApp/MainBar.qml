import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Io
import Quickshell.Services.Mpris
import QtQuick
import QtQuick.Layouts
import "../CustomTheme"

import Quickshell.Services.SystemTray
import Quickshell.Widgets

PanelWindow {
    id: bar
    anchors { top: true; left: true; right: true }
    property var modelData
    property string barFontFamily: "Maple Mono NF CN"
    property int topBarHeight: 44
    property int cornerSize: 20

    screen: modelData
    height: topBarHeight + cornerSize
    WlrLayershell.layer: WlrLayer.Top
    exclusionMode: WlrLayershell.Exclusive
    exclusiveZone: topBarHeight
    WlrLayershell.keyboardFocus: WlrLayershell.None
    color: "transparent"

    // --- SYSTEM DATA ENGINE ---
    QtObject {
        id: sysInfo
        property real volValue: 0.0
        property bool isMuted: false
        property bool isDragging: false
        property string bat: "0%"
        property string wifi: ""
        property bool wifiRadio: false
        property string connType: "none"
        property bool bluetooth: false
        property bool hasBattery: true
        property real cpuUsage: 0.0
        property real ramUsage: 0.0
        property real diskUsage: 0.0
    }

    Process {
        id: volGetter
        running: true
        command: ["bash", "-c", "wpctl get-volume @DEFAULT_AUDIO_SINK@"]
        stdout: SplitParser {
            onRead: {
                if (!sysInfo.isDragging) {
                    let output = data.trim()
                    sysInfo.isMuted = output.includes("[MUTED]")
                    let match = output.match(/[0-9.]+/)
                    if (match) sysInfo.volValue = parseFloat(match[0])
                }
            }
        }
    }

    Process {
        id: batGetter
        running: true
        command: ["bash", "-c", "cat /sys/class/power_supply/BAT0/capacity 2>/dev/null || echo 'none'"]
        stdout: SplitParser {
            onRead: {
                if (data.trim() === "none") sysInfo.hasBattery = false
                else sysInfo.bat = data.trim() + "%"
            }
        }
    }

    Process {
        id: wifiGetter
        running: true
        command: ["bash", "-c",
            "eth=$(nmcli -t -f type,state dev 2>/dev/null | grep '^ethernet:connected' | head -1); " +
            "wifi=$(nmcli -t -f active,ssid dev wifi 2>/dev/null | grep '^yes' | cut -d: -f2); " +
            "if [ -n \"$eth\" ]; then connType=\"ethernet\"; elif [ -n \"$wifi\" ]; then connType=\"wifi\"; else connType=\"none\"; fi; " +
            "echo \"$connType:$wifi\""
        ]
        stdout: SplitParser {
            onRead: {
                let parts = data.trim().split(":")
                sysInfo.connType = parts[0]
                sysInfo.wifi = parts[1] || ""
            }
        }
    }

    Process {
        id: wifiRadioGetter
        running: true
        command: ["bash", "-c", "nmcli radio wifi"]
        stdout: SplitParser {
            onRead: { sysInfo.wifiRadio = data.trim() === "enabled" }
        }
    }

    Process {
        id: btGetter
        running: true
        command: ["bash", "-c", "bluetoothctl show | grep -q 'Powered: yes' && echo 'on' || echo 'off'"]
        stdout: SplitParser {
            onRead: { sysInfo.bluetooth = (data.trim() === "on") }
        }
    }

    Process {
        id: perfGetter
        running: true
        command: ["bash", "-c", "cpu=$(top -bn1 | grep 'Cpu(s)' | awk '{print 100 - $8}'); mem=$(free | grep Mem | awk '{print $3/$2 * 100.0}'); disk=$(df / --output=pcent | tail -1 | tr -dc '0-9'); echo \"$cpu|$mem|$disk\""]
        stdout: SplitParser {
            onRead: {
                let parts = data.trim().split("|")
                if (parts.length >= 3) {
                    sysInfo.cpuUsage = (parseFloat(parts[0]) || 0) / 100
                    sysInfo.ramUsage = (parseFloat(parts[1]) || 0) / 100
                    sysInfo.diskUsage = (parseFloat(parts[2]) || 0) / 100
                }
            }
        }
    }

    Timer {
        interval: 3000; running: true; repeat: true
        onTriggered: {
            batGetter.running = true
            wifiGetter.running = true
            btGetter.running = true
            perfGetter.running = true
        }
    }

    Timer {
        interval: 100; running: true; repeat: true
        onTriggered: {
            volGetter.running = true
            wifiRadioGetter.running = true
        }
    }

    // --- MEDIA (native MPRIS) ---
    property var activePlayer: Mpris.players.values.length > 0 ? Mpris.players.values[0] : null

    Connections {
        target: Mpris.players
        function onValuesChanged() {
            if (Mpris.players.values.length > 0) {
                let found = Mpris.players.values.some(p => p === bar.activePlayer)
                if (!found) bar.activePlayer = Mpris.players.values[0]
            } else {
                bar.activePlayer = null
            }
        }
    }

    // Position ticker — keeps p.position reactive while playing
    Timer {
        interval: 1000; repeat: true
        running: bar.activePlayer !== null && bar.activePlayer.playbackState === MprisPlaybackState.Playing
        onTriggered: { if (bar.activePlayer) bar.activePlayer.positionChanged() }
    }

    // --- EXECUTOR ---
    Process {
        id: executor
        function run(args) { command = args; running = true }
    }

    // --- SWAYNC ---
    property string swayncState: "none"
    Process {
        id: swayncWatcher
        running: true
        command: ["swaync-client", "-swb"]
        stdout: SplitParser {
            onRead: {
                try {
                    let json = JSON.parse(data.trim())
                    bar.swayncState = json.alt
                } catch (e) {}
            }
        }
    }

    function getNotificationIcon(state) {
        if (state.includes("notification")) return "󰂠"
        return state.includes("dnd") ? "󰂛" : "󰂚"
    }

    // --- UI LAYOUT ---
    Rectangle {
        anchors.top: parent.top
        width: parent.width
        height: bar.topBarHeight
        color: Theme.background
        opacity: 0.8
    }

    // Center pill — media info
    Rectangle {
        id: centerPill
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: Math.round((bar.topBarHeight - height) / 2)
        height: 36
        width: Math.min(centerRow.implicitWidth + 38, 540)
        radius: 21
        color: Theme.background
        z: 6

        Row {
            id: centerRow
            anchors.centerIn: parent
            spacing: 9

            Text {
                text: "󰎆"
                color: Theme.primary
                font.family: bar.barFontFamily
                font.pixelSize: 16
                verticalAlignment: Text.AlignVCenter
            }

            Text {
                text: {
                    let title = bar.activePlayer ? (bar.activePlayer.trackTitle || "No Media") : "No Media"
                    let artist = bar.activePlayer ? (bar.activePlayer.trackArtist || "") : ""
                    return title + (artist ? " - " + artist : "")
                }
                color: Theme.primary
                font.family: bar.barFontFamily
                font.pixelSize: 15
                font.weight: Font.Medium
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
                width: Math.min(implicitWidth, 420)
            }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: mediaPopup.active = !mediaPopup.active
        }
    }
    NetSpeed {
        id: netSpeedPill
    
        anchors.left: centerPill.right
        anchors.leftMargin: 10
        anchors.verticalCenter: centerPill.verticalCenter
    
        pillHeight: centerPill.height
        fontFamily: bar.barFontFamily
        fontSize: 12
        iconSize: 13
        updateInterval: 1000
    
        // 屏幕窄时隐藏，避免和右侧音量、时间、系统胶囊重叠
        visible: bar.width > 1300
    }
    
    // YesPlayLyric disabled to save power
    YesPlayLyric {
        id: yesPlayLyric
    
        anchors.right: centerPill.left
        anchors.rightMargin: 12
        anchors.verticalCenter: centerPill.verticalCenter
    
        visible: currentLyric.length > 0 && bar.width > 1150
    
        maxWidth: 460
        lyricFontFamily: bar.barFontFamily
        mainLyricSize: 15
        transLyricSize: 12
        iconSize: 16
    
        showTranslation: true
        lyricOffset: 0.15
      }


    RowLayout {
        anchors.top: parent.top
        width: parent.width
        height: bar.topBarHeight
        anchors.leftMargin: 10
        anchors.rightMargin: 10
        spacing: 0

        // Left: logo + workspaces
        Row {
            Layout.alignment: Qt.AlignLeft
            spacing: 9

            Text {
                text: " 󰣇"
                color: Theme.primary
                font.family: bar.barFontFamily
                font.pixelSize: 26
                anchors.verticalCenter: parent.verticalCenter
                MouseArea {
                    anchors.fill: parent
                    acceptedButtons: Qt.LeftButton | Qt.RightButton
                    onClicked: (mouse) => {
                        if (mouse.button === Qt.LeftButton) executor.run(["bash", "-c", "~/.config/hypr/scripts/launcher.sh"])
                        else executor.run(["bash", "-c", "~/.config/hypr/scripts/keybindings.sh"])
                    }
                }
            }

            Rectangle {
                height: 36
                width: wsRow.width + 24
                radius: 18
                color: Theme.background
                anchors.verticalCenter: parent.verticalCenter

                Row {
                    id: wsRow
                    anchors.centerIn: parent
                    spacing: 13

                    Repeater {
                        model: Hyprland.workspaces
                        Item {
                            width: 18
                            height: 18

                            Text {
                                anchors.centerIn: parent
                                text: modelData.active ? "󰮯" : "󰊠"
                                color: modelData.active ? Theme.on_primary_container : Theme.primary
                                font.family: bar.barFontFamily
                                font.pixelSize: 17
                                verticalAlignment: Text.AlignVCenter
                            }

                            MouseArea {
                                anchors.fill: parent
                                onClicked: executor.run(["hyprctl", "dispatch", "workspace", modelData.name])
                            }
                        }
                    }
                }
            }
        }

        Item { Layout.fillWidth: true }

        // Right: tray, volume, clipboard, notifications, clock, system pill, power
        Row {
            Layout.alignment: Qt.AlignRight
            spacing: 16
            
            // Tray
            Tray {
              id: trayPill

              barWindow: bar
              trayPopup: trayPopup

              iconSize: 16
              itemSize: 22
              itemSpacing: 4

              showPassive: false
              maxIcons: 4

              anchors.verticalCenter: parent.verticalCenter
            }
            // VOLUME
            Row {
                spacing: 8
                anchors.verticalCenter: parent.verticalCenter

                Text {
                    text: sysInfo.isMuted ? "󰝟" : (sysInfo.volValue > 0.6 ? "󰕾" : (sysInfo.volValue > 0.2 ? "󰖀" : "󰕿"))
                    color: sysInfo.isMuted ? Theme.accent : Theme.primary
                    font.family: bar.barFontFamily
                    font.pixelSize: 19
                    verticalAlignment: Text.AlignVCenter
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            executor.run(["bash", "-c", "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"])
                            volGetter.running = true
                        }
                    }
                }

                Rectangle {
                    width: 84
                    height: 7
                    radius: 4
                    color: Theme.background
                    anchors.verticalCenter: parent.verticalCenter

                    Rectangle {
                        width: parent.width * sysInfo.volValue
                        height: parent.height
                        radius: 4
                        color: sysInfo.isMuted ? Theme.accent : Theme.primary
                    }

                    MouseArea {
                        anchors.fill: parent
                        function update(mouse) {
                            sysInfo.isDragging = true
                            let p = Math.max(0, Math.min(1, mouse.x / width))
                            sysInfo.volValue = p
                            executor.run(["wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", p.toFixed(2)])
                        }
                        onPressed: update(mouse)
                        onPositionChanged: update(mouse)
                        onReleased: { sysInfo.isDragging = false; volGetter.running = true }
                        onWheel: (wheel) => {
                            let delta = wheel.angleDelta.y > 0 ? 0.05 : -0.05
                            let newValue = Math.max(0, Math.min(1, sysInfo.volValue + delta))
                            sysInfo.volValue = newValue
                            executor.run(["wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", newValue.toFixed(2)])
                            volGetter.running = true
                        }
                    }
                }
            }

            // CLIPBOARD
            Text {
                text: "󰅌"
                color: Theme.primary
                font.family: bar.barFontFamily
                font.pixelSize: 19
                anchors.verticalCenter: parent.verticalCenter
                verticalAlignment: Text.AlignVCenter
                MouseArea { anchors.fill: parent; onClicked: clipboardPopup.active = !clipboardPopup.active }
            }

            // NOTIFICATIONS
            Text {
                text: getNotificationIcon(bar.swayncState)
                color: Theme.primary
                font.family: bar.barFontFamily
                font.pixelSize: 21
                anchors.verticalCenter: parent.verticalCenter
                verticalAlignment: Text.AlignVCenter
                MouseArea {
                    anchors.fill: parent; acceptedButtons: Qt.LeftButton | Qt.RightButton
                    onClicked: (mouse) => {
                        if (mouse.button === Qt.LeftButton) executor.run(["swaync-client", "-t", "-sw"])
                        else executor.run(["swaync-client", "-d", "-sw"])
                    }
                }
            }

            // CLOCK
            Item {
                width: clockCol.implicitWidth
                height: 40
                anchors.verticalCenter: parent.verticalCenter

                Column {
                    id: clockCol
                    anchors.centerIn: parent
                    spacing: -1
                    property var time: new Date()

                    Timer { interval: 1000; running: true; repeat: true; onTriggered: clockCol.time = new Date() }

                    Text {
                        text: Qt.formatDateTime(clockCol.time, "HH:mm")
                        color: Theme.primary
                        font.family: bar.barFontFamily
                        font.pixelSize: 13
                        font.weight: Font.Black
                        horizontalAlignment: Text.AlignHCenter
                    }

                    Text {
                        text: Qt.formatDateTime(clockCol.time, "AP")
                        color: Theme.primary
                        font.family: bar.barFontFamily
                        font.pixelSize: 11
                        font.weight: Font.Bold
                        horizontalAlignment: Text.AlignHCenter
                    }
                }

                MouseArea { anchors.fill: parent; onClicked: calendarPopup.active = !calendarPopup.active }
            }

            // SYSTEM PILL (network, bt, battery)
            Rectangle {
                height: 36
                width: sysRow.implicitWidth + 28
                radius: 18
                color: Theme.background
                anchors.verticalCenter: parent.verticalCenter

                RowLayout {
                    id: sysRow
                    anchors.centerIn: parent
                    spacing: 10

                    Row {
                        spacing: 4
                        Layout.alignment: Qt.AlignVCenter
                        visible: sysInfo.connType !== "none"

                        Text {
                            text: sysInfo.connType === "ethernet" ? "󰈀" : "󰤨"
                            color: Theme.primary
                            font.family: bar.barFontFamily
                            font.pixelSize: 13
                            verticalAlignment: Text.AlignVCenter
                        }

                        Text {
                            text: sysInfo.wifi
                            color: Theme.primary
                            font.family: bar.barFontFamily
                            font.pixelSize: 14
                            font.weight: Font.Bold
                            visible: sysInfo.connType === "wifi" && sysInfo.wifi !== ""
                            verticalAlignment: Text.AlignVCenter
                        }
                    }

                    Text {
                        text: "󰂯"
                        color: Theme.primary
                        font.family: bar.barFontFamily
                        font.pixelSize: 15
                        visible: sysInfo.bluetooth
                        Layout.alignment: Qt.AlignVCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    Row {
                        spacing: 4
                        visible: sysInfo.hasBattery
                        Layout.alignment: Qt.AlignVCenter

                        Text {
                            text: "󰂄"
                            color: Theme.primary
                            font.family: bar.barFontFamily
                            font.pixelSize: 13
                            verticalAlignment: Text.AlignVCenter
                        }

                        Text {
                            text: sysInfo.bat
                            color: Theme.primary
                            font.family: bar.barFontFamily
                            font.pixelSize: 14
                            font.weight: Font.Bold
                            verticalAlignment: Text.AlignVCenter
                        }
                    }
                }

                MouseArea { anchors.fill: parent; onClicked: systemPopup.active = !systemPopup.active }
            }

            // POWER
            Text {
                text: "󰐥  "
                color: Theme.primary
                font.family: bar.barFontFamily
                font.pixelSize: 19
                anchors.verticalCenter: parent.verticalCenter
                verticalAlignment: Text.AlignVCenter
                MouseArea { anchors.fill: parent; onClicked: powerPopup.active = !powerPopup.active }
            }
        }
    }

    MediaPopup { id: mediaPopup; screen: bar.screen }
    SystemPopup { id: systemPopup }
    CalendarPopup { id: calendarPopup }
    ClipboardPopup { id: clipboardPopup; screen: bar.screen }
    PowerPopup { id: powerPopup; screen: bar.screen }
    TrayPopup {
        id: trayPopup
        barWindow: bar
        iconSize: 22
        itemSize: 36
        itemSpacing: 6
        showPassive: false
        maxIcons: 4
    }

    Canvas {
        opacity: 0.8
        id: leftCorner
        x: 10
        y: bar.topBarHeight
        width: bar.cornerSize
        height: bar.cornerSize
        property color syncColor: Theme.background
        onSyncColorChanged: requestPaint()
        onPaint: {
            var ctx = getContext("2d"); ctx.reset()
            ctx.fillStyle = Theme.background
            ctx.moveTo(0, 0); ctx.lineTo(bar.cornerSize, 0)
            ctx.arcTo(0, 0, 0, bar.cornerSize, bar.cornerSize); ctx.fill()
        }
    }

    Canvas {
        opacity: 0.8
        id: rightCorner
        x: parent.width - 30
        y: bar.topBarHeight
        width: bar.cornerSize
        height: bar.cornerSize
        property color syncColor: Theme.background
        onSyncColorChanged: requestPaint()
        onPaint: {
            var ctx = getContext("2d"); ctx.reset()
            ctx.fillStyle = Theme.background
            ctx.moveTo(bar.cornerSize, 0); ctx.lineTo(0, 0)
            ctx.arcTo(bar.cornerSize, 0, bar.cornerSize, bar.cornerSize, bar.cornerSize); ctx.fill()
        }
    }
}
