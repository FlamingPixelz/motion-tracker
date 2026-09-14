import QtQuick
import QtQuick.Layouts
import org.kde.plasma.plasmoid
import QtQuick.Controls

PlasmoidItem {
    id: root
    preferredRepresentation: compactRepresentation
    property color backgroundColour: "#130F1D"

    BluetoothManager {
        id: bluetoothManager
    }

    compactRepresentation: Item {
        width: 32
        height: 32

        MouseArea {
            anchors.fill: parent
            onClicked: root.expanded = !root.expanded
        }

        Image {
           anchors.centerIn: parent
           width: 28
           height: 28
           source: "../assets/icons/forerunner-bt.svg" 
           fillMode: Image.PreserveAspectFit
        }
    }

    FontLoader {
        id: haloFont
        source: "../assets/fonts/HandelGothic.ttf"
    }


    fullRepresentation: Item {
        Layout.minimumWidth: 550
        Layout.minimumHeight: 300

        Rectangle {
            anchors.fill: parent
            color: backgroundColour
        }

        // Turn BT on/off button
        Rectangle {
            id: btButton
            width: 60
            height: 60
            radius: 8
            color: "transparent"
            scale: mouseArea.pressed ? 0.92 : 1.0

            Image {
                anchors.centerIn: parent
                width: 40
                height: 40
                source: bluetoothManager.bluetoothEnabled ? "../assets/icons/fog-off.svg": "../assets/icons/fog-on.svg" 
                fillMode: Image.PreserveAspectFit
                mipmap: false
            }

            MouseArea {
                id: mouseArea
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: bluetoothManager.toggleBt()
            }
            
            Behavior on scale {
                NumberAnimation {
                    duration: 100
                    easing.type: Easing.InOutQuad
                }
            }
        }

        Radar {
            id: radarDisplay
            anchors.top: parent.top
            anchors.topMargin: 100
            anchors.left: parent.left
            anchors.leftMargin: 40
            width: 150
            height: 150
            devicesModel: bluetoothManager.devicesModel
            visible: bluetoothManager.bluetoothEnabled
            active: root.expanded && bluetoothManager.bluetoothEnabled
            radarColour: bluetoothManager.discovering ? "#495F94" : "#8c2ca2"
            scale: scanMouseArea.pressed ? 0.92 : 1.0

            // Start scan
            MouseArea {
                id: scanMouseArea
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: bluetoothManager.discovering ? bluetoothManager.stopScan() : bluetoothManager.startScan()
            }

            Behavior on scale {
                NumberAnimation {
                    duration: 100
                    easing.type: Easing.InOutQuad
                }
        }
    }

        Image {
            id: offImage
            anchors.top: parent.top
            anchors.topMargin: 60
            anchors.horizontalCenter: parent.horizontalCenter
            width: 200
            height: 200
            source: "../assets/icons/fog-skull.png" 
            fillMode: Image.PreserveAspectFit
            visible: !bluetoothManager.bluetoothEnabled
            opacity: 0.4
            smooth: false
            mipmap: false
        }

        Text {
            anchors.top: offImage.bottom
            anchors.topMargin: 8
            anchors.horizontalCenter: parent.horizontalCenter

            text: "You'll miss those eyes in the back of your head"
            font.family: haloFont.name
            color: '#544970'
            font.pixelSize: 18
            visible: !bluetoothManager.bluetoothEnabled
        }

        ListView {
            id: deviceList
            property string expandedAddress: ""
            anchors.top: parent.top
            anchors.topMargin: 30
            anchors.left: radarDisplay.right
            anchors.leftMargin: 60
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.margins: 8
            clip: true
            visible: bluetoothManager.bluetoothEnabled
            model: bluetoothManager.devicesModel

            delegate: Rectangle {
                id: deviceDelegate
                width: deviceList.width
                color: "transparent"
                clip: true

                property bool expanded: deviceList.expandedAddress === model.address
                property var liveDevice: expanded ? bluetoothManager.deviceForAddress(model.address) : null

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
                                width: 8
                                height: 8
                                radius: 4
                                color: model.connected ? "#D58AB6" : (model.paired ? "#DA3E62" : "#544970")
                            }

                            Text {
                                text: model.name
                                color: "#e0d8ec"
                                font.family: haloFont.name
                                font.pixelSize: 13
                                Layout.fillWidth: true
                                elide: Text.ElideRight
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: deviceList.expandedAddress = deviceDelegate.expanded ? "" : model.address
                        }
                    }

                    ColumnLayout {
                        id: detailColumn
                        width: parent.width
                        visible: deviceDelegate.expanded
                        spacing: 6

                        Text {
                            text: "MAC: " + model.address
                            color: "#a495c2"
                            font.pixelSize: 11
                        }

                        Text {
                            text: "Battery: " + (deviceDelegate.liveDevice && deviceDelegate.liveDevice.battery
                                ? deviceDelegate.liveDevice.battery.percentage + "%"
                                : "—")
                            color: "#a495c2"
                            font.pixelSize: 11
                        }

                        RowLayout {
                            spacing: 6

                            TextField {
                                id: aliasField
                                Layout.fillWidth: true
                                text: model.name
                                placeholderText: "Alias"
                            }

                            Button {
                                text: "Save"
                                onClicked: bluetoothManager.setDeviceAlias(model.address, aliasField.text)
                            }
                        }

                        RowLayout {
                            spacing: 6

                            Button {
                                visible: !model.paired
                                text: "Pair"
                                onClicked: bluetoothManager.pairDevice(model.address)
                            }

                            Button {
                                visible: model.paired
                                text: model.connected ? "Disconnect" : "Connect"
                                onClicked: model.connected
                                    ? bluetoothManager.disconnectDevice(model.address)
                                    : bluetoothManager.connectDevice(model.address)
                            }

                            Button {
                                visible: model.paired
                                text: "Forget"
                                onClicked: {
                                    deviceList.expandedAddress = ""
                                    bluetoothManager.forgetDevice(model.address)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}