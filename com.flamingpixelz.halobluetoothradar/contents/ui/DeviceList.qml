import QtQuick
import QtQuick.Layouts

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
                        height: 28

                        RowLayout {
                            anchors.fill: parent
                            spacing: 8

                            Rectangle {
                                width: 7
                                height: 7
                                radius: 3.5
                                color: model.connected ? "#D58AB6" : (model.paired ? "#DA3E62" : "#544970")
                            }

                            Text {
                                text: model.name
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