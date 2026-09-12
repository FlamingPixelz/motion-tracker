import QtQuick
import org.kde.bluezqt as BluezQt

Item {
    id: root

    readonly property BluezQt.Manager manager: BluezQt.Manager
    property alias devicesModel: devicesModel
    readonly property bool bluetoothEnabled: manager.bluetoothOperational

    // Turn BT on/off
    function toggleBt() {
        var enable = !manager.bluetoothOperational

        if(enable && manager.bluetoothBlocked) {
            console.log("Bluetooth is blocked, cannot enable")
            manager.bluetoothBlocked = false
            return
        }
        for(var i = 0; i < manager.adapters.length; i++) {
            manager.adapters[i].powered = enable
        }
    }

    function startScan() {
        var adapter = manager.usableAdapter
        if(adapter && !adapter.discovering) {
            adapter.startDiscovery()
        }
    }

    function stopScan() {
        var adapter = manager.usableAdapter 
        if(adapter && adapter.discovering) {
            adapter.stopDiscovery()
        }
    }

    ListModel {
        id: devicesModel
    }

    // Search for entry whose adress matches
    function indexOfDevice(address) {
        for(var i = 0; i < devicesModel.count; i++) {
            if(devicesModel.get(i).address === address) {
                return i
            }
        }
        return -1
    }

    // Converts BluezQt device into plan JS object
    function deviceToEntry(device) {
        return {
            address: device.address || "",
            name: device.name || device.address || "Unknown",
            rssi: (device.rssi !== undefined && device.rssi !== null) ? device.rssi : 0, // Signal strength
            connected: device.connected === true
        }
    }

    Connections {
        target: root.manager

        // When becomes operational, clear model and repopulate it with every known device
        function onOperationalChanged() {

            if (root.manager.operational) {
                devicesModel.clear()
                for(var i = 0; i < root.manager.devices.length; i++) {
                    devicesModel.append(deviceToEntry(root.manager.devices[i]))
                }
            }
        }

        // Adds new device only if it already isnt present
        function onDeviceAdded(device) {
            if (indexOfDevice(device.address) === -1) {
                devicesModel.append(deviceToEntry(device))
            }
        }

        // Removes device
        function onDeviceRemoved(device) {
            var idx = indexOfDevice(device.address)
            if(idx !== -1) devicesModel.remove(idx)
        }

        // Device updates
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