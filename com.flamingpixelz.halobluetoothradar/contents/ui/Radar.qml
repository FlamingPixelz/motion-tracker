import QtQuick

Item {
    id: radar
    property string radarColour: '#8c2ca2'
    property string blipColour: "#DA3E62"

        // Arc
        property real sliceDegrees: 70
        property real sliceRadians: sliceDegrees * Math.PI / 180
        property real centre: -Math.PI / 2
        property real startAngle: centre - sliceRadians / 2
        property real endAngle: centre + sliceRadians / 2

        Rectangle {
            anchors.fill: parent
            color: "#130F1D"

            Rectangle {
                anchors.centerIn: parent
                width: 150
                height: 150
                color: "transparent"
                radius: height/2
                border.width: 2
                border.color: radarColour

                //Blips
                Repeater {
                    model: 4

                    Rectangle {
                        width: 6
                        height: 6
                        radius: height/2
                        color: blipColour

                        property var positions: [
                            Qt.point(100, 40),
                            Qt.point(120, 90),
                            Qt.point(65, 30),
                            Qt.point(10, 70)
                        ]

                        x: positions[index].x
                        y: positions[index].y

                    SequentialAnimation on opacity {
                        loops: Animation.Infinite

                        NumberAnimation {
                            from: 0.4
                            to: 1.0
                            duration: 1200
                            easing.type: Easing.InOutQuad
                        }
                        NumberAnimation {
                            from: 1.0
                            to: 0.3
                            duration: 1200
                            easing.type: Easing.InOutQuad
                        }
                        PauseAnimation {
                            duration: index * 250
                        }
                    }

                    SequentialAnimation on scale {
                        loops: Animation.Infinite

                        NumberAnimation {
                            from: 0.8
                            to: 1.0
                            duration: 1200
                            easing.type: Easing.InOutQuad
                        }

                        NumberAnimation {
                            from: 1.0
                            to: 0.8
                            duration: 1200
                            easing.type: Easing.InOutQuad
                        }
                    }
                }
            }

                Canvas {
                    anchors.fill: parent
                    onPaint: {
                        var ctx = getContext("2d")
                        ctx.reset()

                        var cx = width / 2
                        var cy = height / 2
                        var r = width / 2 - 2

                        ctx.beginPath()

                        ctx.moveTo(cx, cy)

                        ctx.arc(
                            cx, cy, r, startAngle, 
                            endAngle, false 
                        )

                        var gradient = ctx.createRadialGradient(
                            cx,cy,0,
                            cx,cy,r
                        )

                        gradient.addColorStop(0, radarColour)
                        gradient.addColorStop(0.95, "transparent")
                        
                        ctx.lineTo(cx, cy)
                        ctx.globalAlpha = 0.7
                        ctx.fillStyle = gradient
                        ctx.fill()
                        ctx. stroke()
                    }
                }
                // Pulse Animation
                Rectangle {
                    id: pulse
                    anchors.centerIn: parent

                    width: 150
                    height: 150
                    radius: height/2

                    color: "transparent"
                    border.color: radarColour
                    border.width: 3
                    scale: 0
                    opacity: 1.0

                SequentialAnimation {
                    running: true
                    loops: Animation.Infinite

                     ParallelAnimation {
                         NumberAnimation {
                            target: pulse
                            property: "scale"
                            from: 0
                            to: 1
                            duration: 1500
                            easing.type: Easing.OutQuad
                }

                        NumberAnimation {
                            target: pulse
                            property: "opacity"
                            from: 1.0
                            to: 0.0
                            duration: 1500
                }

                        NumberAnimation {
                            target: pulse
                            property: "border.width"
                            from: 3
                            to: 6
                            duration: 1500
                            easing.type: Easing.OutQuad
                        }
            }

                 PauseAnimation {
                    duration: 1000
            }

                PropertyAction {
                    target: pulse
                    property: "scale"
                    value: 0
            }

                PropertyAction {
                    target: pulse
                    property: "opacity"
                    value: 1.0
            }
        }
     }
}

            Rectangle {
                anchors.centerIn: parent
                width: 45
                height: 45
                color: radarColour
                radius: height/2
                opacity: 0.4
            }
        }
}