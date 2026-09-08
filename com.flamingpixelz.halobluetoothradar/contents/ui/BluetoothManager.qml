import QtQuick
import org.kde.bluezqt as BluezQt

Item {
    id: root

    readonly property BluezQt.Manager manager: BluezQt.Manager
    property alias devicesModel: devicesModel

    ListModel {
        id: devicesModel
    }

    function indexOfDevice(address) {
        for(var i = 0; i < devicesModel.count; i++) {
            if(devicesModel.get(i).address === address) {
                return i
            }
            return -1
        }
    }

    Connections {
        target: root.manager

        function onOperationalChanged() {
            console.log("=== Operational:", root.manager.operational, "===")
            if (root.manager.operational && root.manager.usableAdapter) {
                console.log(
                    "Adapter:",
                    root.manager.usableAdapter.name,
                    root.manager.usableAdapter.address
                )
                root.manager.usableAdapter.startDiscovery()
            }
            printDevices()
        }

        function onDeviceAdded(device) {
            console.log("Device found:", device.name, device.address, "RSSI:", device.rssi)
        }

        function onDeviceRemoved(device) {
            console.log("Device removed", device.address)
        }

        function onDeviceChanged(device) {
            console.log(
                "Device Changed:", device.name, device.address,
                "RSSI:", device.rssi, "Connected:", device.connected
            )
        }
    }

    function printDevices() {
        console.log("Existing devices:", manager.devices.length)
        for (var i = 0; i < manager.devices.length; i++) {
            var device = manager.devices[i]
            console.log(
                "Device:", device.name, device.address,
                "RSSI:", device.rssi, "Connected:", device.connected
            )
        }
    }
}