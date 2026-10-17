import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic
import QtQuick.Effects

Item {
    id: root
    property var btManagerScan: null
    property var scanningDuration: 60*1000
    readonly property bool scanning: btManagerScan ? btManagerScan.discovering : false

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
            width: progress.visualPosition * parent.width
            height: parent.height
            color: "#364770"
        }

        Rectangle {
        x: fill.width
        width: 12
        height: parent.height
        gradient: Gradient {
            orientation: Gradient.Horizontal
            GradientStop { position: 0.0; color: "#495F94" }
            GradientStop { position: 1.0; color: "#00495F94" }
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
}


