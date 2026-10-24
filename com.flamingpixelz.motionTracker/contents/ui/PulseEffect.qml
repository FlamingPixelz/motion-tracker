import QtQuick
import QtQuick.Effects

Item {
    id: root
    property real pulseSize: 260
    property int pulseCount: 5
    property real next: 0
    property color pulseColour: "#7660af"

    NumberAnimation on next {
        from: 0
        to: 1
        duration: 8000
        loops: Animation.Infinite
        running: root.visible
    }

    Repeater {
        model: root.pulseCount

        Rectangle {
            property int index: model.index
            property real offset: (root.next + index / root.pulseCount) % 1
            id: pulse
            anchors.centerIn: root

            layer.enabled: true
            layer.effect: MultiEffect {
                blurEnabled: true
                autoPaddingEnabled: true   
                blurMax: 80
                blur: pulse.offset
            }

            width: pulseSize
            height: width
            radius: width / 2
            color: pulseColour
            scale: 1 - (1 - offset) * (1 - offset) 
            opacity: Math.pow(1 - offset, 2)
        }
    }
}