import QtQuick

Rectangle {
    id: root
    width: ListView.view.width
    height: 50
    color: "transparent"

    required property string deviceName
    required property real deviceRssi
    required property bool deviceConnected
    required property string deviceAddress

    signal clicked()

    Row {
        anchors.fill: parent
        anchors.margins: 8
        spacing: 12

        Text {
            text: root.deviceName
            color: "white"
            anchors.verticalCenter: parent.verticalCenter
        }

        Text {
            text: root.deviceConnected ? "Connected" : root.deviceRssi + " dBm"
            color: root.deviceConnected ? "#4CAF50" : "#888888"
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: root.clicked()
    }
}