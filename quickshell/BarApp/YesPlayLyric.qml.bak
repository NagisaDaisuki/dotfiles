import QtQuick
import QtQuick.Layouts
import "../CustomTheme"

Rectangle {
    id: root

    property string playerApi: "http://127.0.0.1:27232/player"
    property string lyricApiPrefix: "http://127.0.0.1:10754/lyric?id="

    property string lyricFontFamily: "Maple Mono NF CN"

    property int maxWidth: 360
    property int pollInterval: 350

    property int pillHeight: 40
    property int iconSize: 14
    property int mainLyricSize: 13
    property int transLyricSize: 10

    property string trackId: ""
    property string fetchingTrackId: ""
    property real progress: 0

    property var lyricLines: []
    property var lyricCache: ({})

    property string currentLyric: ""
    property string currentTrans: ""
    property string currentTitle: ""

    property bool showTranslation: true

    // 歌词提前/延后，单位秒
    // 歌词慢：调大，例如 0.7
    // 歌词快：调小，例如 0.25
    property real lyricOffset: 0.55

    width: visible ? maxWidth : 0
    height: pillHeight
    radius: pillHeight / 2

    visible: currentLyric.length > 0
    color: Theme.background
    opacity: 0.92
    clip: true

    Behavior on width {
        NumberAnimation {
            duration: 140
            easing.type: Easing.OutCubic
        }
    }

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 10
        anchors.rightMargin: 10
        spacing: 7

        Text {
            text: "󰎈"
            color: Theme.primary

            font.family: root.lyricFontFamily
            font.pixelSize: root.iconSize
            font.weight: Font.Bold
            font.letterSpacing: 0
            font.wordSpacing: 0

            verticalAlignment: Text.AlignVCenter
            Layout.alignment: Qt.AlignVCenter
        }

        ColumnLayout {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignVCenter
            spacing: 0

            Text {
                id: mainLine

                text: root.currentLyric
                color: Theme.primary

                font.family: root.lyricFontFamily
                font.pixelSize: root.currentTrans.length > 0 ? root.mainLyricSize : root.mainLyricSize + 1
                font.weight: Font.Bold
                font.letterSpacing: 0
                font.wordSpacing: 0

                elide: Text.ElideRight
                maximumLineCount: 1
                Layout.fillWidth: true
                verticalAlignment: Text.AlignVCenter
            }

            Text {
                text: root.currentTrans
                visible: root.showTranslation && root.currentTrans.length > 0

                color: Theme.on_surface_variant

                font.family: root.lyricFontFamily
                font.pixelSize: root.transLyricSize
                font.weight: Font.Medium
                font.letterSpacing: 0
                font.wordSpacing: 0

                elide: Text.ElideRight
                maximumLineCount: 1
                Layout.fillWidth: true
                verticalAlignment: Text.AlignVCenter
            }
        }
    }

    Timer {
        interval: root.pollInterval
        running: true
        repeat: true
        triggeredOnStart: true

        onTriggered: {
            root.updatePlayer()
        }
    }

    function requestJson(url, callback) {
        var xhr = new XMLHttpRequest()

        xhr.onreadystatechange = function() {
            if (xhr.readyState !== 4)
                return

            if (xhr.status >= 200 && xhr.status < 300) {
                try {
                    callback(JSON.parse(xhr.responseText), null)
                } catch (e) {
                    callback(null, "JSON parse failed: " + e)
                }
            } else {
                callback(null, "HTTP " + xhr.status)
            }
        }

        try {
            xhr.open("GET", url)
            xhr.send()
        } catch (e) {
            callback(null, "Request failed: " + e)
        }
    }

    function normalizeTrackId(id) {
        if (id === undefined || id === null)
            return ""

        var s = String(id).trim()

        if (s.length === 0 || s === "0" || s === "-1" || s === "undefined" || s === "null")
            return ""

        return s
    }

    function updatePlayer() {
        requestJson(root.playerApi, function(data, err) {
            // 接口偶尔失败时，不清空当前歌词，避免闪烁
            if (err || !data || !data.currentTrack)
                return

            var track = data.currentTrack
            var newId = normalizeTrackId(track.id)

            root.currentTitle = track.name || ""
            root.progress = readProgress(data, track)

            // id 临时没拿到时，只继续用当前进度匹配歌词
            if (newId.length === 0) {
                root.pickCurrentLine()
                return
            }

            // 歌曲变化：立即处理，不做两次确认，避免歌词变慢
            if (newId !== root.trackId) {
                root.trackId = newId

                if (root.lyricCache[newId]) {
                    root.lyricLines = root.lyricCache[newId]
                    root.pickCurrentLine()
                    return
                }

                root.lyricLines = []

                if (root.fetchingTrackId !== newId) {
                    root.fetchingTrackId = newId

                    // 只有当前没歌词时才显示加载中，避免反复闪
                    if (root.currentLyric.length === 0)
                        root.currentLyric = "歌词加载中…"

                    root.currentTrans = ""
                    root.fetchLyrics(newId)
                }

                return
            }

            // 当前歌曲歌词正在请求中时，不反复改成“歌词加载中”
            if (root.fetchingTrackId === root.trackId && root.lyricLines.length === 0)
                return

            root.pickCurrentLine()
        })
    }

    function readProgress(data, track) {
        var candidates = [
            track.progress,
            data.progress,
            data.currentTime,
            data.position,
            data.time
        ]

        for (var i = 0; i < candidates.length; ++i) {
            var v = candidates[i]

            if (v === undefined || v === null || v === "")
                continue

            var n = Number(v)

            if (isNaN(n))
                continue

            // 兼容毫秒
            if (n > 10000)
                return n / 1000

            // 兼容秒
            return n
        }

        // 没取到时沿用上一次进度，避免归零导致卡在第一行
        return root.progress
    }

    function fetchLyrics(id) {
        var requestId = String(id)

        requestJson(root.lyricApiPrefix + encodeURIComponent(requestId), function(data, err) {
            // 如果请求返回时已经切歌，丢弃旧结果
            if (root.fetchingTrackId !== requestId)
                return

            root.fetchingTrackId = ""

            if (err || !data || Number(data.code) !== 200) {
                root.lyricLines = []

                if (root.trackId === requestId) {
                    root.currentLyric = "暂无歌词"
                    root.currentTrans = ""
                }

                return
            }

            var lrc = parseLrc(data.lrc && data.lrc.lyric ? data.lrc.lyric : "")
            var tlyric = parseLrc(data.tlyric && data.tlyric.lyric ? data.tlyric.lyric : "")
            var romalrc = parseLrc(data.romalrc && data.romalrc.lyric ? data.romalrc.lyric : "")

            var merged = mergeLyrics(lrc, tlyric, romalrc)

            root.lyricLines = merged

            var cache = root.lyricCache
            cache[requestId] = merged
            root.lyricCache = cache

            if (root.lyricLines.length === 0) {
                root.currentLyric = "暂无歌词"
                root.currentTrans = ""
            } else {
                root.pickCurrentLine()
            }
        })
    }

    function parseLrc(raw) {
        var result = []

        if (!raw || raw.length === 0)
            return result

        var lines = raw.split("\n")

        for (var i = 0; i < lines.length; ++i) {
            var line = lines[i].trim()

            if (line.length === 0)
                continue

            // 跳过 [by:xxx] 这种元信息
            if (line.match(/^\[[a-zA-Z]+:/))
                continue

            var tagRe = /\[(\d{1,2}):(\d{2})(?:[.:](\d{1,3}))?\]/g
            var tags = []
            var match

            while ((match = tagRe.exec(line)) !== null) {
                var min = Number(match[1])
                var sec = Number(match[2])
                var fracText = match[3] || "0"
                var frac = 0

                if (fracText.length === 1)
                    frac = Number(fracText) / 10
                else if (fracText.length === 2)
                    frac = Number(fracText) / 100
                else
                    frac = Number(fracText) / 1000

                tags.push(min * 60 + sec + frac)
            }

            var text = line.replace(tagRe, "").trim()
            text = normalizeLyricText(text)

            if (shouldSkipLyricText(text))
                continue

            for (var j = 0; j < tags.length; ++j) {
                result.push({
                    time: tags[j],
                    text: text
                })
            }
        }

        result.sort(function(a, b) {
            return a.time - b.time
        })

        return result
    }

    function normalizeLyricText(text) {
        if (!text)
            return ""

        var t = text.trim()

        // 全角空格转半角空格
        t = t.replace(/\u3000/g, " ")

        // 删除中文、日文字符之间人为插入的空格
        t = t.replace(/([\u3040-\u30ff\u3400-\u9fff])\s+(?=[\u3040-\u30ff\u3400-\u9fff])/g, "$1")

        // 删除中日文和常见中文/日文标点之间的空格
        t = t.replace(/([\u3040-\u30ff\u3400-\u9fff])\s+(?=[，。！？、」』）〕】》：；])/g, "$1")
        t = t.replace(/([「『（〔【《])\s+(?=[\u3040-\u30ff\u3400-\u9fff])/g, "$1")

        // 英文歌词只压缩连续空格，不直接删除单词间空格
        t = t.replace(/\s{2,}/g, " ")

        return t
    }

    function shouldSkipLyricText(text) {
        if (!text || text.trim().length === 0)
            return true

        var t = text.trim()

        // 过滤作词、作曲、编曲等制作信息
        if (t.match(/^(作词|作曲|编曲|制作人|制作|监制|混音|母带|录音|和声|吉他|贝斯|鼓|键盘|弦乐|出品|发行|企划|统筹|OP|SP|PV|MV)\s*[:：]/))
            return true

        // 过滤英文制作信息
        if (t.match(/^(Lyricist|Composer|Arranger|Producer|Mixing|Mastering|Recording|Guitar|Bass|Drums|Vocal)\s*[:：]/i))
            return true

        // 过滤网易云常见元信息
        if (t.match(/^(\[.*\]|by:|翻译:|译:|校对:)/i))
            return true

        return false
    }

    function timeKey(t) {
        return Math.round(t * 100).toString()
    }

    function buildMap(lines) {
        var map = {}

        for (var i = 0; i < lines.length; ++i)
            map[timeKey(lines[i].time)] = lines[i].text

        return map
    }

    function findNearestText(lines, time, threshold) {
        var bestText = ""
        var bestDiff = 999

        for (var i = 0; i < lines.length; ++i) {
            var diff = Math.abs(lines[i].time - time)

            if (diff < bestDiff) {
                bestDiff = diff
                bestText = lines[i].text
            }
        }

        return bestDiff <= threshold ? bestText : ""
    }

    function mergeLyrics(lrc, tlyric, romalrc) {
        var base = lrc.length > 0 ? lrc : tlyric
        var transMap = buildMap(tlyric)
        var romanMap = buildMap(romalrc)

        var merged = []

        for (var i = 0; i < base.length; ++i) {
            var t = base[i].time
            var key = timeKey(t)

            var trans = transMap[key] || findNearestText(tlyric, t, 0.35)
            var roma = romanMap[key] || findNearestText(romalrc, t, 0.35)

            merged.push({
                time: t,
                text: base[i].text,
                trans: trans || "",
                roma: roma || ""
            })
        }

        merged.sort(function(a, b) {
            return a.time - b.time
        })

        return merged
    }

    function pickCurrentLine() {
        if (!root.lyricLines || root.lyricLines.length === 0) {
            if (root.fetchingTrackId.length === 0) {
                root.currentLyric = ""
                root.currentTrans = ""
            }
            return
        }

        var t = root.progress + root.lyricOffset
        var index = -1

        var left = 0
        var right = root.lyricLines.length - 1

        while (left <= right) {
            var mid = Math.floor((left + right) / 2)

            if (root.lyricLines[mid].time <= t) {
                index = mid
                left = mid + 1
            } else {
                right = mid - 1
            }
        }

        if (index < 0) {
            root.currentLyric = ""
            root.currentTrans = ""
            return
        }

        var line = root.lyricLines[index]

        root.currentLyric = line.text || ""
        root.currentTrans = line.trans || ""
    }
}
