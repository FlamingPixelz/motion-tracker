import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic
import QtQuick.Effects

Item {
    id: root
    property var btManagerScan: null
    property var scanningDuration: 60*1000
    readonly property bool scanning: btManagerScan ? btManagerScan.discovering : false
    property int flashDuration: 14500
    property bool flashing: false

    property real barStart: 0.10
    property real barEnd: 0.89
    property int sweepDuration: Math.max(1, scanningDuration - flashDuration)

    onScanningChanged: {
        flashing = scanning
        if(scanning) flashTimer.restart()
        else flashTimer.stop()
    }

    Timer {
        id: flashTimer
        interval: root.flashDuration
        onTriggered: root.flashing = false
    }

    Image {
        anchors.fill: parent
        source: "../assets/icons/purple-health.svg"
        sourceSize: Qt.size(width * 2, height * 2)
        visible: !root.scanning
    }

    onVisibleChanged: {
        if(!(btManagerScan && btManagerScan.discovering)) {
            progress.value = 0
        }
    }

    ProgressBar {

    id: progress
    layer.enabled: true
    layer.smooth: true
    anchors.fill: parent
    visible: false
    value: 0
    from: 0
    to: 1
    padding: 0

    background: Rectangle {
        color: "transparent"
    }

    contentItem: Item {
        Rectangle {
            id: fill
            antialiasing: true
            x: root.barStart * parent.width
            width: progress.value * (root.barEnd - root.barStart) * parent.width
            height: parent.height
            color: "#364770"
        }

        Rectangle {
            x: fill.x + fill.width
            width: 16
            height: parent.height
            antialiasing: true
            visible: progress.value > 0       // no feather sitting there during the flash
            gradient: Gradient {
                orientation: Gradient.Horizontal
                GradientStop { position: 0.0; color: "#364770" }
                GradientStop { position: 1.0; color: "#00364770" }
            }
        }
    }

    NumberAnimation {
    target: progress
    property: "value"
    from: 0
    to: 1
    duration: root.scanningDuration
    easing.type: Easing.Linear
    running: root.scanning
}


    onVisibleChanged: {
        if(!(btManagerScan && btManagerScan.discovering)) {
            progress.value = 0
        }
    }

    Connections {
        target: btManagerScan
        function onDiscoveringChanged() {
            progress.value = 0
        }
    }
}

    Image {
        id: mask
        anchors.fill: parent
        source: "../assets/icons/scan-health-mask.svg"
        sourceSize.width: width * 2
        sourceSize.height: height * 2
        layer.smooth: true
        visible: false
        layer.enabled: true
    }

    MultiEffect {
        anchors.fill: parent
        source: progress
        maskEnabled: true
        maskSource: mask
        visible: root.scanning
    }

    Image {
        anchors.fill: parent
        source: "../assets/icons/scan-health.svg"
        sourceSize.width: width * 2
        sourceSize.height: height * 2
        visible: root.scanning
    }

    Image {
        id: flash
        anchors.fill: parent
        source: "../assets/icons/scan-flash.svg"
        sourceSize.width: width * 2
        sourceSize.height: height * 2
        visible: root.flashing
        opacity: 0

        SequentialAnimation on opacity {
            running: root.flashing
            loops: Animation.Infinite
            NumberAnimation{ to: 1.0; duration: 300 }
            NumberAnimation {to: 0.0; duration: 300 }
        }

    }
}


