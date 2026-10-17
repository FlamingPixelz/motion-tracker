import QtQuick
import QtQuick.Layouts
import org.kde.plasma.plasmoid
import QtQuick.Controls
import QtQuick.Effects

PlasmoidItem {
    id: root
    preferredRepresentation: compactRepresentation
    property color backgroundColour: "#0D0D14"
    property color purpleHighlight: '#7660af'
    property color radarScanning: "#495F94"
    property color radarColor: "#5a468c"
    property color textboxColor: '#1a1428'
    property color redHighlight: "#DA3E62"
    property var scanningLimit: 1000*60

    property var btEnabled: bluetoothManager.bluetoothEnabled
    property var btDiscovering: bluetoothManager.discovering

    BluetoothManager {
        id: bluetoothManager
    }

    Timer {
        interval: scanningLimit
        running: btDiscovering
        onTriggered: {
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

        // Widget Icon
        Image {
           anchors.centerIn: parent
           width: 32
           height: 32
           source: btDiscovering
           ? "../assets/icons/bluetooth-scanning.svg" :
           bluetoothManager.devicesConnected() 
           ? "../assets/icons/bluetooth-connected.svg" :
            btEnabled ? 
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
            anchors.margins: -5
        }

        // Turn BT on/off button
        Rectangle {
            id: btButton
            width: 60
            height: 60
            radius: 8
            color: "transparent"
            scale: mouseArea.containsMouse ? 1.2 : 1.1

            Image {
                anchors.centerIn: parent
                width: 200
                height: 200
                source: btEnabled ? "../assets/icons/fog-off.svg": "../assets/icons/fog-on.svg" 
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
            visible: btEnabled
            active: root.expanded && btEnabled
            radarColour: btDiscovering ? radarScanning : radarColor
            scale: scanMouseArea.pressed ? 0.95 : 1.0

            // Start scan
            MouseArea {
                id: scanMouseArea
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: btDiscovering ? bluetoothManager.stopScan() : bluetoothManager.startScan()
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
        height: 6
        visible: btDiscovering
        btManagerScan: bluetoothManager
    }

    TextAnimation {
    anchors.top: radarDisplay.bottom
    anchors.topMargin: 24 
    anchors.horizontalCenter: radarDisplay.horizontalCenter
    width: radarDisplay.width
    status: btEnabled ? bluetoothManager.statusState : "idle"
    fontFamily: haloFont.name
    textColour: purpleHighlight
    failedColour: redHighlight
}

        // BT Off Screen
        Image {
            id: offImage
            anchors.top: parent.top
            anchors.topMargin: 50
            anchors.horizontalCenter: parent.horizontalCenter
            width: 200
            height: 200
            sourceSize.width: width * 2
            sourceSize.height: height * 2
            source: "../assets/icons/fog-skull.svg" 
            fillMode: Image.PreserveAspectFit
            visible: !btEnabled
            smooth: true
            mipmap: false

                PulseEffect {
                anchors.centerIn: parent
                anchors.horizontalCenterOffset: 2
                anchors.verticalCenterOffset: -10
                z: -1
        }
        }

        Rectangle {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: offImage.bottom
            anchors.topMargin: 15
            color: textboxColor
            width: 450
            height: 25
            visible: !btEnabled

            Rectangle {
                anchors.left: parent.left
                width: 5
                height: 25
                color: purpleHighlight
                opacity: 0.6
                visible: !btEnabled
    }
            Rectangle {
                anchors.right: parent.right
                width: 5
                height: 25
                color: purpleHighlight
                opacity: 0.6
                visible: !btEnabled
    }

         Text {
            
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.leftMargin: 40
            anchors.topMargin: 4
            text: "YOU'LL MISS THOSE EYES IN THE BACK OF YOUR HEAD"
            font.family: haloFont.name
            color: purpleHighlight
            font.pixelSize: 14
            visible: !btEnabled
        }           
}

        DeviceList {
            id: deviceList
            anchors.top: parent.top
            anchors.topMargin: 50
            anchors.left: radarDisplay.right
            anchors.leftMargin: 30
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            visible: btEnabled

            btManager: bluetoothManager
            fontFamily: haloFont.name
        }
    }
}