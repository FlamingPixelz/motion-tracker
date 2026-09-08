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

    function deviceToEntry(device) {
        return {
            address: device.address,
            name: device.name || device.address,
            rssi: device.rssi,
            connected: device.connected
        }
    }

    Connections {
        target: root.manager

        function onOperationalChanged() {

            if (root.manager.operational) {
                devicesModel.clear()
                for(var i = 0; i < root.manager.devices.length; i++) {
                    devicesModel.append(deviceToEntry(root.manager.devices[i]))
                }
            }
        }

        function onDeviceAdded(device) {
            if (indexOfDevice(device.address) === -1) {
                devicesModel.append(deviceToEntry(device))
            }
        }

        function onDeviceRemoved(device) {
            var idx = indexOfDevice(device.address)
            if(idx !== -1) devicesModel.remove(idx)
        }

        function onDeviceChanged(device) {
            var idx = indexOfDevice(device.address) 
            var entry = deviceToEntry(device)
            if(idx !== -1) {
                devicesModel.set(idx, entry)
            } else {
                devicesModel.append(entry)
            }
        }
    }
}