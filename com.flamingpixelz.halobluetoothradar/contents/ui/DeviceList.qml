import QtQuick
import QtQuick.Layouts
import QtQuick.Shapes

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
                            width: 540
                            height: 40
                            Layout.alignment: Qt.AlignVCenter
                            layer.enabled: true
                            layer.samples: 8

                            ShapePath {
                                id: shapeContainer
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
                            height: 160
                            Image {
                                id: dropdownEnergy
                                anchors.horizontalCenter: shapeContainer.horizontalCenter
                                anchors.top: parent.top
                                anchors.topMargin: -60
                                width: 300
                                height: 300
                                sourceSize: Qt.size(width * 2, height * 2)
                                mipmap: false
                                smooth: true
                                source: "../assets/icons/dropdown.svg"
                            }
                        }
                    }
                }
            }
        }