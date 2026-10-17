import QtQuick

    Text {
    id: root

    property string status: "idle"
    property string fontFamily: ""
    property color textColour: "#7660af"
    property color failedColour: "#DA3E62"
    property int dots: 0
    property string shownStatus: "idle"

    TextMetrics {
    id: fullMetrics
    font: root.font
    text: "Connecting..."  
}

    onStatusChanged: if(status != "idle") {
        shownStatus = status
    }

    elide: Text.ElideRight
    horizontalAlignment: shownStatus === "connecting" ? Text.AlignLeft : Text.AlignHCenter
    leftPadding: shownStatus === "connecting"
             ? Math.max(0, (width - fullMetrics.advanceWidth) / 2)
             : 0
             
    font.family: fontFamily
    font.pixelSize: 14
    text: shownStatus === "connecting" ? "Connecting" + ".".repeat(dots) : "Failed to Connect"
    color: shownStatus === "failed" ? failedColour : textColour
    opacity: status === "idle" ? 0:1
    visible: opacity > 0

    Behavior on opacity {
        NumberAnimation {
            duration: root.status === "idle" ? 2000 : 1500
            easing.type: Easing.InOutQuad
        }
    }

    Timer {
        interval: 400
        repeat: true
        running: root.status === "connecting"
        onRunningChanged: if(running) {
            root.dots = 0
        }
        onTriggered: root.dots = (root.dots + 1) % 4
    }
}