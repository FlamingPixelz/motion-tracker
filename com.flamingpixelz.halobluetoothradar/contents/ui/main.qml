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

    onExpandedChanged: {
        if (root.expanded) {
            bluetoothManager.startScan()
        } else {
            bluetoothManager.stopScan()
        }
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
        Layout.minimumWidth: 300
        Layout.minimumHeight: 200

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
            anchors.centerIn: parent
            width: 150
            height: 150
            devicesModel: bluetoothManager.devicesModel
            visible: bluetoothManager.bluetoothEnabled
            active: root.expanded && bluetoothManager.bluetoothEnabled
        }

                DeviceList {
            width: parent.width
            height: 200
            manager: bluetoothManager
}


        Image {
            id: offImage
            anchors.centerIn: parent
            anchors.verticalCenterOffset: -20
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

        


    }
}
