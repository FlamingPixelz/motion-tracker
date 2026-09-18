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

                property bool expanded: root.expandedAddress === model.address
                property var liveDevice: expanded ? btManager.deviceForAddress(model.address) : null

                height: headerRow.height + (expanded ? detailColumn.height + 12 : 0)

                Behavior on height {
                    NumberAnimation { duration: 150; easing.type: Easing.OutQuad }
                }

                Column {
                    width: parent.width

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
                                strokeWidth: 2
                                strokeColor: "#544970"
                                fillColor: "transparent"

                                startX: 0;  startY: 32
                                PathLine { x: 8; y: 4 }
                                PathLine { x: 285; y: 4 }
                                PathLine { x: 275; y: 32 }
                                PathLine { x: 0; y: 32 }
                                
                            }
                            Rectangle {
                                anchors.left: parent.left
                                anchors.leftMargin: 10
                                anchors.top: parent.top
                                anchors.topMargin: 14
                                width: 6
                                height: 6
                                radius: 3.5
                                color: model.connected ? "#D58AB6" : (model.paired ? "#DA3E62" : "#544970")
                            }

                            Text {
                                text: model.name
                                anchors.left: parent.left
                                anchors.leftMargin: 20
                                anchors.top: parent.top
                                anchors.topMargin: 10
                                color: "#e0d8ec"
                                font.family: root.fontFamily
                                font.pixelSize: 12
                                Layout.fillWidth: true
                                elide: Text.ElideRight
                            }
                        }       
                        }
                    }
                }
            }
        }