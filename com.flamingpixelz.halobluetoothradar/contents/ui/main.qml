import QtQuick
import QtQuick.Layouts
import org.kde.plasma.plasmoid

PlasmoidItem {
    id: root

    preferredRepresentation: fullRepresentation
    fullRepresentation: Item {
        Layout.minimumWidth: 200
        Layout.minimumHeight: 200

        Rectangle {
            anchors.fill: parent
            color: "#04140a"
            border.color: "#00ff78"
            border.width: 2

            Text {
                anchors.centerIn: parent
                text: "It works"
                color: "#00ff78"
                font.pixelSize: 24
                font.family: "monospace"
            }

            Rectangle {
                width: 20; height: 20
                color: "#00ff78"
                x: 10; y: 10

                SequentialAnimation on opacity {
                    loops: Animation.Infinite
                    NumberAnimation { to: 0.2; duration: 800 }
                    NumberAnimation { to: 1.0; duration: 800 }
                }
            }
        }
    }
}
