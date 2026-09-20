import QtQuick

Item {
    id: radar
    property string radarColour: '#8c2ca2'
    property string blipColour: "#DA3E62"
    property string connectedBlip: "#D58AB6"
    property string unpairedBlip: "#544970"
    property real radarSize: 150
    property var devicesModel: null
    property bool active: true

    // Arc
    property real sliceDegrees: 70
    property real sliceRadians: sliceDegrees * Math.PI / 180
    property real centre: -Math.PI / 2
    property real startAngle: centre - sliceRadians / 2
    property real endAngle: centre + sliceRadians / 2

    property real pulseRadius: 0

    property real blipJolt: 0.09
    property real blipSpeed: 0.5

        // Radar Circle
        Rectangle {
            anchors.fill: parent
            color: "transparent"

            Rectangle {
                anchors.centerIn: parent
                width: radarSize
                height: radarSize
                color: "transparent"
                radius: height/2
                border.width: 2
                border.color: radarColour

                // Wedge
                Canvas {
                    id: wedgeCanvas
                    anchors.fill: parent

                    Connections {
                        target: radar
                        function onRadarColourChanged() {
                            wedgeCanvas.requestPaint()
                        }
                    }

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
                    }
                }
                // Pulse Animation
                Rectangle {
                    id: pulse
                    anchors.centerIn: parent

                    width: radarSize
                    height: radarSize
                    radius: height/2

                    color: "transparent"
                    border.color: radarColour
                    border.width: 3
                    scale: 0
                    opacity: 1.0

                SequentialAnimation {
                    running: radar.active
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
                            target: radar
                            property: "pulseRadius"
                            from: 0
                            to: 75
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
                    target: radar
                    property: "pulseRadius"
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
            // Inner Circle
            Rectangle {
                anchors.centerIn: parent
                width: radarSize/(10/3)
                height: radarSize/(10/3)
                color: radarColour
                radius: height/2
                opacity: 0.4
            }

                //Blips
                Repeater {

                    model: radar.devicesModel

                    Rectangle {
                        id: blip
                        property real normalSize: 6
                        property real detectedSize: 7
                        property bool detected: false
                        width: detected ? detectedSize : normalSize
                        height: detected ? detectedSize : normalSize
                        radius: height/2
                        color: model.connected ? connectedBlip : (model.paired ? blipColour : unpairedBlip)

                        Component.onCompleted: {

                            var angle = Math.random() * Math.PI * 2
                            var dist = Math.random() * 65
                            blip.x = radarSize/2 + Math.cos(angle) * dist
                            blip.y = radarSize/2 + Math.sin(angle) * dist   

                            fadeAnimation.start()
                        }

                        Behavior on width {
                            NumberAnimation {
                                duration: 150
                                easing.type: Easing.OutQuad
                            }
                        }

                        Behavior on height {
                            NumberAnimation {
                                duration: 150
                                easing.type: Easing.OutQuad
                            }
                        }


                        property real velocityX: (Math.random() - 0.5) * blipSpeed
                        property real velocityY: (Math.random() - 0.5) * blipSpeed

                        // Random movement
                        Timer {
                            interval: 50
                            running: radar.active
                            repeat: true

                            onTriggered: {

                                blip.velocityX += (Math.random() - 0.5 ) * blipJolt
                                blip.velocityY += (Math.random() - 0.5 ) * blipJolt
                                blip.velocityX = Math.max(-1.2, Math.min(1.2, blip.velocityX))
                                blip.velocityY = Math.max(-1.2, Math.min(1.2, blip.velocityY))

                                var newX = blip.x + blip.velocityX
                                var newY = blip.y + blip.velocityY

                                var centreX = radarSize/2
                                var centreY = radarSize/2
                                var maxRadius = radarSize/2 - 10

                                var dx = newX - centreX
                                var dy = newY - centreY
                                var dist = Math.sqrt(dx * dx + dy * dy)

                                if(dist > maxRadius) {
                                    var nx = dx / dist
                                    var ny = dy / dist
                                    var dot = blip.velocityX * nx + blip.velocityY * ny

                                    blip.velocityX -= 2 * dot * nx
                                    blip.velocityY -= 2 * dot * ny

                                    newX = centreX + nx * maxRadius
                                    newY = centreY + ny * maxRadius
                                }

                                blip.x = newX
                                blip.y = newY
                            }
                        }

                        // Blip increasing in size when hit by pulse
                        Timer {
                            interval: 30
                            running: radar.active
                            repeat: true

                            onTriggered: {
                                var dx = blip.x + blip.width / 2 - radarSize/2
                                var dy = blip.y + blip.height / 2 - radarSize/2
                                var distance = Math.sqrt(dx * dx + dy * dy)
                                var difference = Math.abs(distance - radar.pulseRadius)

                                if(difference < 4 && !blip.detected) {
                                    blip.opacity = 1.0
                                    fadeAnimation.restart()
                                    blip.detected = true
                                    detectedTimer.restart()
                                }
                        }
                    }
                    // Blip remains large for set period
                    Timer {
                        id: detectedTimer 
                        interval: 300
                        repeat: false

                        onTriggered: {
                            blip.detected = false
                        }
                    }

                    // Blip fades
                    NumberAnimation {
                        id: fadeAnimation
                        target: blip
                        property: "opacity"
                        from: 1.0
                        to: 0.2
                        duration: 3000
                        easing.type: Easing.Linear
                    }
                }
            }
        }
}