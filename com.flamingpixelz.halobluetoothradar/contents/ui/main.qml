import QtQuick
import QtQuick.Layouts
import org.kde.plasma.plasmoid
import QtQuick.Controls
import QtQuick.Effects

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
           width: 32
           height: 32
           source: bluetoothManager.discovering 
           ? "../assets/icons/bluetooth-scanning.svg" :
           bluetoothManager.devicesConnected() 
           ? "../assets/icons/bluetooth-connected.svg" :
            bluetoothManager.bluetoothEnabled ? 
            "../assets/icons/bluetooth-idle.svg" 
            : "../assets/icons/bluetooth-off.svg" 
           sourceSize.width: width * 2
           sourceSize.height: height * 2
           fillMode: Image.PreserveAspectFit
           smooth: true
           mipmap: false
        }
    }

    FontLoader {
        id: haloFont
        source: "../assets/fonts/HandelGothic.ttf"
    }


    fullRepresentation: Item {
        Layout.minimumWidth: 450
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
            scale: mouseArea.pressed ? 1.02 : 1.1

            Image {
                anchors.centerIn: parent
                width: 200
                height: 200
                source: bluetoothManager.bluetoothEnabled ? "../assets/icons/fog-off.svg": "../assets/icons/fog-on.svg" 
                sourceSize.width: width
                sourceSize.height: height
                fillMode: Image.PreserveAspectFit
                smooth: true
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
            anchors.topMargin: 60
            anchors.left: parent.left
            anchors.leftMargin: 20
            width: 150
            height: 150
            devicesModel: bluetoothManager.devicesModel
            visible: bluetoothManager.bluetoothEnabled
            active: root.expanded && bluetoothManager.bluetoothEnabled
            radarColour: bluetoothManager.discovering ? "#495F94" : "#5a468c"
            scale: scanMouseArea.pressed ? 0.95 : 1.0

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

    ScanningBar {
        anchors.top: radarDisplay.bottom
        anchors.left: radarDisplay.left
        anchors.topMargin: 10
        width: 150
        height: 10
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

        DeviceList {
            id: deviceList
            anchors.top: parent.top
            anchors.topMargin: 50
            anchors.left: radarDisplay.right
            anchors.leftMargin: 30
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            visible: bluetoothManager.bluetoothEnabled

            btManager: bluetoothManager
            fontFamily: haloFont.name
        }
    }
}