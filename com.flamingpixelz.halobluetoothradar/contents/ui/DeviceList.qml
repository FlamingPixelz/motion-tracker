import QtQuick
import QtQuick.Layouts
import QtQuick.Shapes
import QtQuick.Controls

 ListView {
            id: root
            property string expandedAddress: ""
            property var btManager
            property string fontFamily: ""
            clip: true
            model: btManager ? btManager.devicesModel : null

            delegate: Rectangle {
                
                id: deviceDelegate
                width: root.width
                color: "transparent"
                clip: true

                
                property bool checkGroup: {
                    if (index <= 0) return true
                    var previous = root.model.get(index-1)
                    return !previous || previous.group !== model.group
                }

                property bool expanded: root.expandedAddress === model.address
                property var liveDevice: (expanded || model.connected) ? btManager.deviceForAddress(model.address) : null
                property int batteryPercentage: (liveDevice && liveDevice.battery) ? liveDevice.battery.percentage: -1

                height: (checkGroup ? 30: 0) + headerRow.height + (expanded ? detailColumn.height + 12 : 0)

                Behavior on height {
                    NumberAnimation { duration: 150; easing.type: Easing.OutQuad }
                }

                Column {
                    width: parent.width

                Item {
                visible: deviceDelegate.checkGroup
                width: parent.width
                height: visible ? 30 : 0


                    Text {
                        text: model.group === "allies" ? "Allies" : (model.group === "contacts" ? "Contacts": "Nearby")
                        color: '#544970'
                        font.family: root.fontFamily
                        font.underline: true
                        font.pixelSize: 15
                        anchors.left: parent.left
                        anchors.top: parent.top
                        anchors.topMargin: 10
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: 8

                }
            }                    

                    Item {
                        id: headerRow
                        width: parent.width
                        height: 35

                        RowLayout {
                            anchors.fill: parent
                            spacing: 12

                        Shape {
                            id: shapeContainer
                            width: 540
                            height: 40
                            Layout.alignment: Qt.AlignVCenter
                            layer.enabled: true
                            layer.samples: 8

                            ShapePath {
                                strokeWidth: 2
                                fillColor: colourChange.containsMouse ? '#1b152a' : "transparent"
                                strokeColor: "#544970"

                                startX: 2;  startY: 32
                                PathLine { x: 7; y: 10 }
                                PathQuad { controlX: 8; controlY: 4; x: 14; y: 4 }
                                PathLine { x: 289; y: 4 }
                                PathQuad { controlX: 301; controlY: 4; x: 298; y: 10 }
                                PathLine { x: 290; y: 32 }
                                PathLine { x: 2; y: 32 }
                                
                            }
                            Rectangle {
                                anchors.left: parent.left
                                anchors.leftMargin: 11
                                anchors.top: parent.top
                                anchors.topMargin: 14.5
                                width: 6
                                height: 6
                                radius: 3.5
                                color: model.connected ? "#D58AB6" : (model.paired ? "#DA3E62" : "#544970")
                            }

                            Text {
                                text: model.name
                                anchors.left: parent.left
                                anchors.leftMargin: 21
                                anchors.top: parent.top
                                anchors.topMargin: 10
                                color: "#e0d8ec"
                                font.family: root.fontFamily
                                font.pixelSize: 12
                                Layout.fillWidth: true
                                elide: Text.ElideRight
                            }

                            Image {
                                id: batteryImage
                                anchors.top: parent.top
                                anchors.topMargin: 0
                                anchors.right: parent.right
                                anchors.rightMargin: 45
                                source: "../assets/icons/battery.svg" 
                                width: 35
                                height: 35
                                mipmap: false
                                smooth: true
                                visible: model.connected && batteryPercentage >= 0

                                Text {
                                    visible: batteryImage.visible
                                    text: batteryPercentage
                                    anchors.centerIn: parent
                                    font.pixelSize: 8
                                    font.family: root.fontFamily
                                    color: "#e0d8ec"
                                }
                            }

                            Image {
                                id: connectBtn
                                anchors.top: parent.top
                                anchors.topMargin: 5.5
                                anchors.right: parent.right
                                anchors.rightMargin: 11.5
                                width: 25
                                height: 25
                                mipmap: false
                                smooth: true
                                visible: !model.connected && model.paired
                                source: connectHover.containsMouse ? "../assets/icons/connect1-hover.svg": "../assets/icons/connect1.svg"
                                scale: connectHover.containsMouse ? 1.1 : 1.0
                                z: 1

                                MouseArea {
                                    id: connectHover
                                    anchors.fill: connectBtn
                                    cursorShape: Qt.PointingHandCursor
                                    hoverEnabled: true
                                    onClicked: btManager.connectDevice(model.address)
                                }

                            }
                            Image {
                                id: pairBtn
                                anchors.top: parent.top
                                anchors.topMargin: 5
                                anchors.right: parent.right
                                anchors.rightMargin: 11
                                width: 25
                                height: 25
                                mipmap: false
                                smooth: true
                                source: pairHover.containsMouse ? "../assets/icons/pair-hover.svg": "../assets/icons/pair.svg"
                                scale: pairHover.containsMouse ? 1.1 : 1.0
                                visible: !model.connected && !model.paired
                                z: 1

                                MouseArea {
                                    id: pairHover
                                    anchors.fill: pairBtn
                                    cursorShape: Qt.PointingHandCursor
                                    hoverEnabled: true
                                    onClicked: btManager.pairDevice(model.address)
                                }

                            }                            

                            Image {
                                id: disconnectBtn
                                anchors.top: parent.top
                                anchors.topMargin: 2
                                anchors.right: parent.right
                                anchors.rightMargin: 10
                                width: 30
                                height: 30
                                mipmap: false
                                smooth: true
                                source: disconnectHover.containsMouse ? "../assets/icons/disconnect-br-hover.svg": "../assets/icons/disconnect-br.svg"
                                scale: disconnectHover.containsMouse ? 1.05 : 1.0
                                visible: model.connected
                                z: 1

                                MouseArea {
                                    id: disconnectHover
                                    anchors.fill: disconnectBtn
                                    cursorShape: Qt.PointingHandCursor
                                    hoverEnabled: true
                                    onClicked: btManager.disconnectDevice(model.address)
                                }

                                Behavior on scale {

                                    NumberAnimation{
                                        duration: 100
                                        easing.type: Easing.InOutQuad 
                                    }
                                }
                            }

                            MouseArea {
                                id: colourChange
                                anchors.fill: parent
                                hoverEnabled: true
                                onClicked: root.expandedAddress = deviceDelegate.expanded ? "" : model.address
                            }
                        }       
                        }
                    }

                    // Dropdown list
                    Column {
                        id: detailColumn
                        width: parent.width
                        topPadding: 0

                        Item {
                            width: parent.width
                            height: 110

                            Text {
                                visible: model.typeName !== ""
                                text: model.typeName
                                anchors.left: parent.left
                                anchors.leftMargin: 5
                                anchors.top: parent.top
                                anchors.topMargin: 5
                                color: "#544970"
                                font.family: root.fontFamily
                                font.pixelSize: 14
                                Layout.fillWidth: true

                            }

                            TextField {
                                id: aliasInput
                                anchors.top: parent.top
                                anchors.topMargin: 25
                                anchors.left: parent.left
                                anchors.leftMargin: 5
                                width: 230
                                placeholderText: "Alias"
                                font.family: root.fontFamily
                                // Press Enter 
                                onAccepted: {
                                    if(text.trim() !== "") {
                                        btManager.setDeviceAlias(model.address, text.trim())
                                    }
                                }

                                background: Rectangle {
                                    color: aliasInput.enabled ? "transparent" : "#353637"
                                    border.color: aliasInput.enabled ? "#544970" : "transparent"
                                }

                                Image {
                                    id: resetAlias
                                    anchors.top: parent.top
                                    anchors.topMargin: 1
                                    anchors.right: parent.right
                                    anchors.rightMargin: 2
                                    width: 25
                                    height: 25
                                    source: aliasHover.containsMouse ? "../assets/icons/reset-hover.svg" : "../assets/icons/reset.svg"
                                    scale: aliasHover.containsMouse ? 1.05 : 1.0
                                    z: 1

                                    MouseArea {
                                        id: aliasHover
                                        anchors.fill: resetAlias
                                        hoverEnabled: true
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked: btManager.resetAlias(model.address)

                                    }
                                }
                            }

                            Text {
                                text: "Mac: " + model.address
                                anchors.left: parent.left
                                anchors.leftMargin: 5
                                anchors.top: parent.top
                                anchors.topMargin: 60
                                color: "#544970"
                                font.family: root.fontFamily
                                font.pixelSize: 12
                                Layout.fillWidth: true
                                
                            }

                            Image {
                                id: blockBtn
                                anchors.top: parent.top
                                anchors.left: parent.left
                                anchors.leftMargin: 250
                                anchors.topMargin: 20
                                width: 40
                                height: 40
                                mipmap: false
                                source: model.blocked ? "../assets/icons/killjoy-activated.svg" : "../assets/icons/killjoy.svg"
                                scale: activateBlock.containsMouse ? 1.1 : 1.0

                                MouseArea {
                                    id: activateBlock
                                    anchors.fill: blockBtn
                                    cursorShape: Qt.PointingHandCursor
                                    hoverEnabled: true
                                    onClicked: btManager.blockDevice(model.address, !model.blocked)
                                }
                            }

                            Image {
                                id: forgetBtn
                                visible: model.paired
                                anchors.top: parent.top
                                anchors.left: parent.left
                                anchors.leftMargin: 50
                                anchors.topMargin: 80
                                width: 40
                                height: 40
                                mipmap: false
                                source: forgetHover.containsMouse ? "../assets/icons/forget-hover.svg" : "../assets/icons/forget.svg"
                                scale: forgetHover.containsMouse ? 1.1 : 1.0

                                MouseArea {
                                    id: forgetHover
                                    anchors.fill: forgetBtn
                                    cursorShape: Qt.PointingHandCursor
                                    hoverEnabled: true
                                    onClicked: {
                                        root.expandedAddress = ""
                                        btManager.forgetDevice(model.address)
                                    }
                                }
                            }

                            Image {
                                id: trustBtn
                                visible: model.paired
                                anchors.top: parent.top
                                anchors.left: parent.left
                                anchors.leftMargin: 5
                                anchors.topMargin: 80
                                width: 40
                                height: 40
                                mipmap: false
                                source: model.trusted ? "../assets/icons/trust-activated.svg" : "../assets/icons/trust.svg"
                                scale: trustActivate.containsMouse ? 1.1 : 1.0

                                MouseArea {
                                    id: trustActivate
                                    anchors.fill: trustBtn
                                    cursorShape: Qt.PointingHandCursor
                                    hoverEnabled: true
                                    onClicked: btManager.setTrusted(model.address, !model.trusted)
                                }
                            }
                        }
                    }
                }
            }
        }