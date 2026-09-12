import QtQuick

ListView {
    id: root
    clip: true

    property var manager

    model: manager.devicesModel

    delegate: DeviceListItem {
        deviceName: model.name !== undefined ? model.name : "Unknown"
        deviceRssi: model.rssi !== undefined ? model.rssi : 0
        deviceConnected: model.connected === true
        deviceAddress: model.address !== undefined ? model.address : ""
        onClicked: console.log("Clicked device:", deviceAddress)
}
}