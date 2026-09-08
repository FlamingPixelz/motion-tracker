import QtQuick
import QtQuick.Layouts
import org.kde.plasma.plasmoid

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
        Layout.minimumWidth: 300
        Layout.minimumHeight: 200

        Rectangle {
            anchors.fill: parent
            color: backgroundColour
        }

        Text {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: 10

                text: "...Connect Devices..."
                font.family: haloFont.name
                color: '#544970'
                font.pixelSize: 16
            }

        Radar {
            anchors.centerIn: parent
            width: 150
            height: 150
        }


    }
}
