import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import "../CustomTheme"

Rectangle {
    id: root

    property string fontFamily: "Maple Mono NF CN"
    property int pillHeight: 36
    property int fontSize: 12
    property int iconSize: 13
    property int updateInterval: 1000

    property string iface: ""
    property real downSpeed: 0
    property real upSpeed: 0

    property real lastRx: -1
    property real lastTx: -1
    property real lastTime: 0

    width: netRow.implicitWidth + 22
    height: pillHeight
    radius: pillHeight / 2
    color: Theme.background
    opacity: 0.92
    clip: true

    RowLayout {
        id: netRow
        anchors.centerIn: parent
        spacing: 8

        Text {
            text: "↓"
            color: Theme.primary
            font.family: root.fontFamily
            font.pixelSize: root.iconSize
            font.weight: Font.Bold
            verticalAlignment: Text.AlignVCenter
            Layout.alignment: Qt.AlignVCenter
        }

        Text {
            text: root.formatSpeed(root.downSpeed)
            color: Theme.primary
            font.family: root.fontFamily
            font.pixelSize: root.fontSize
            font.weight: Font.Bold
            verticalAlignment: Text.AlignVCenter
            Layout.alignment: Qt.AlignVCenter
        }

        Text {
            text: "↑"
            color: Theme.on_surface_variant
            font.family: root.fontFamily
            font.pixelSize: root.iconSize
            font.weight: Font.Bold
            verticalAlignment: Text.AlignVCenter
            Layout.alignment: Qt.AlignVCenter
        }

        Text {
            text: root.formatSpeed(root.upSpeed)
            color: Theme.on_surface_variant
            font.family: root.fontFamily
            font.pixelSize: root.fontSize
            font.weight: Font.Bold
            verticalAlignment: Text.AlignVCenter
            Layout.alignment: Qt.AlignVCenter
        }
    }

    Process {
        id: netGetter
        running: true

        command: [
            "bash",
            "-c",
            /*
              优先用 nmcli 找真实的 wifi/ethernet 设备。
              如果没找到，再回退到 ip route。
              这样比直接读 default route 更适合 Clash/TUN 场景，
              避免读到 tun、docker、veth、lo 之类虚拟网卡。
            */
            "dev=$(nmcli -t -f DEVICE,TYPE,STATE dev status 2>/dev/null | " +
            "awk -F: '$3==\"connected\" && ($2==\"wifi\" || $2==\"ethernet\") {print $1; exit}'); " +

            "if [ -z \"$dev\" ]; then " +
            "dev=$(ip route get 1.1.1.1 2>/dev/null | awk '{for(i=1;i<=NF;i++) if($i==\"dev\") {print $(i+1); exit}}'); " +
            "fi; " +

            "if [ -z \"$dev\" ] || [ ! -r \"/sys/class/net/$dev/statistics/rx_bytes\" ]; then " +
            "echo 'none|0|0'; " +
            "else " +
            "rx=$(cat /sys/class/net/$dev/statistics/rx_bytes); " +
            "tx=$(cat /sys/class/net/$dev/statistics/tx_bytes); " +
            "echo \"$dev|$rx|$tx\"; " +
            "fi"
        ]

        stdout: SplitParser {
            onRead: {
                root.updateSpeed(data.trim())
            }
        }
    }

    Timer {
        interval: root.updateInterval
        running: true
        repeat: true
        triggeredOnStart: true

        onTriggered: {
            netGetter.running = true
        }
    }

    function updateSpeed(line) {
        var parts = line.split("|")

        if (parts.length < 3)
            return

        var dev = parts[0]
        var rx = Number(parts[1])
        var tx = Number(parts[2])
        var now = Date.now()

        if (dev === "none" || isNaN(rx) || isNaN(tx)) {
            root.iface = ""
            root.downSpeed = 0
            root.upSpeed = 0
            return
        }

        if (root.iface !== dev) {
            root.iface = dev
            root.lastRx = rx
            root.lastTx = tx
            root.lastTime = now
            root.downSpeed = 0
            root.upSpeed = 0
            return
        }

        if (root.lastRx >= 0 && root.lastTx >= 0 && root.lastTime > 0) {
            var deltaTime = Math.max((now - root.lastTime) / 1000, 0.001)
            var rxDiff = Math.max(rx - root.lastRx, 0)
            var txDiff = Math.max(tx - root.lastTx, 0)

            root.downSpeed = rxDiff / deltaTime
            root.upSpeed = txDiff / deltaTime
        }

        root.lastRx = rx
        root.lastTx = tx
        root.lastTime = now
    }

    function formatSpeed(bytesPerSecond) {
        var v = Math.max(bytesPerSecond, 0)

        if (v < 1024)
            return Math.round(v) + "B/s"

        if (v < 1024 * 1024) {
            var k = v / 1024
            return k < 10 ? k.toFixed(1) + "K/s" : Math.round(k) + "K/s"
        }

        var m = v / 1024 / 1024
        return m < 10 ? m.toFixed(1) + "M/s" : Math.round(m) + "M/s"
    }
}
