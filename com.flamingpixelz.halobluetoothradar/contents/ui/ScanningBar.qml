import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic

ProgressBar {
    property var btManagerScan: null
    property var scanningDuration: 60*1000

    id: control
    value: 0
    from: 0
    to: 1
    padding: 2

    background: Rectangle {
        implicitWidth: 150
        implicitHeight: 6
        color: '#1a1428'
        radius: 3
    }

    contentItem: Item {
        
        Rectangle {
            width: control.visualPosition * parent.width
            height: parent.height
            radius: 2
            color: "#495F94"
        }
    }

    Behavior on value {
        NumberAnimation {
            duration: 100
            easing.type: Easing.Linear
        }
    }

    Timer {
        interval: 100
        repeat: true
        running: btManagerScan ? btManagerScan.discovering : false
        onTriggered: {
            if(control.value < control.to) {
                control.value += 100 / scanningDuration
            } else {
                control.value = 0
            }
        }
    }

    onVisibleChanged: {
        if(!(btManagerScan && btManagerScan.discovering)) {
            control.value = 0
        }
    }

    Connections {
        target: btManagerScan
        function onDiscoveringChanged() {
            control.value = 0
        }
    }
}
