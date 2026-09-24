import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic


ProgressBar {
    id: control
    value: 0
    from: 0
    to: 1
    padding: 2

    background: Rectangle {
        implicitWidth: 150
        implicitHeight: 6
        color: "#3C344F"
        radius: 3
    }

    contentItem: Item {
        
        Rectangle {
            width: control.visualPosition * parent.width
            height: parent.height
            radius: 2
            color: "#495F94"
            visible: !control.indeterminate
        }
    }

    Behavior on value {
        NumberAnimation {
            duration: 5000
            easing.type: Easing.Linear
        }
    }

    Timer {
        interval: 5000
        repeat: true
        running: true
        onTriggered: {
            if(control.value < control.to) {
                control.value += 1
            } else {
                running =false
            }
        }
    }
}
