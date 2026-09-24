import QtQuick
import org.kde.bluezqt as BluezQt

Item {
    id: root

    readonly property BluezQt.Manager manager: BluezQt.Manager
    property alias devicesModel: devicesModel
    property real numberOfConnected: 0
    property bool isConnected : false
    readonly property bool bluetoothEnabled: manager.bluetoothOperational
    readonly property bool discovering: manager.usableAdapter ? manager.usableAdapter.discovering : false

    function toggleBt() {
        var enable = !manager.bluetoothOperational

        if(enable && manager.bluetoothBlocked) {
            manager.bluetoothBlocked = false
            return
        }
        for(var i = 0; i < manager.adapters.length; i++) {
            numberOfConnected = 0
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

        function deviceForAddress(address) {
            var adapter = manager.usableAdapter
            return adapter ? adapter.deviceForAddress(address) : null
        }

        function connectDevice(address) {
            var device = deviceForAddress(address)
            if (device) {
                device.connectToDevice() 
            }
        }

        function disconnectDevice(address) {
            var device = deviceForAddress(address)
            if (device) {
                device.disconnectFromDevice()
            }
        }
        
        function devicesConnected() {
            if (numberOfConnected > 0) {
                return isConnected = true
            } else {
                return isConnected = false
            }
        }

        function forgetDevice(address) {
            var adapter = manager.usableAdapter
            var device = deviceForAddress(address)
            if (adapter && device) {
                if(device.connected === true) {
                    numberOfConnected--;
                    console.log("Devices Connected: " + numberOfConnected)
                }
                adapter.removeDevice(device)
            }

            var index = indexOfDevice(address)
            if(index !== -1) devicesModel.remove(index)
        }

        function setDeviceAlias(address, alias) {
            var device = deviceForAddress(address)
            if (device) device.name = alias
        }

        function resetAlias(address) {
            var device = deviceForAddress(address) 
            if(device) device.name = ""
        }

        function setTrusted(address, value) {
            var device = deviceForAddress(address)
            if(device) device.trusted = value
        } 

        function blockDevice(address, value) {
            var device = deviceForAddress(address)
            if(device) device.blocked = value
        }

        function addEntry(entry) {
            if(entry.group === "allies") {
                devicesModel.insert(0, entry)
            }
            else if (entry.group === "nearby") {
                devicesModel.append(entry)
            } 
            else {
                var i = 0
                while(i < devicesModel.count && devicesModel.get(i).group !== "nearby") i++
                devicesModel.insert(i, entry)
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
        var connected = device.connected === true
        var paired = device.paired === true
        return {
            address: device.address,
            trusted: device.trusted === true,
            blocked: device.blocked === true,
            type: device.type !== undefined ? device.type : 0,
            typeName: deviceType(device.type),
            name: device.name || device.address || "Unknown",
            rssi: (device.rssi !== undefined && device.rssi !== null) ? device.rssi : 0, // Signal strength
            connected: device.connected === true,
            paired: device.paired === true,
            group: connected ? "allies": (paired ? "contacts": "nearby")
        }
    }

    // Map device type to text
    function deviceType(type) {
        switch(type) {
            case BluezQt.Device.Phone : return "Smartphone"
            case BluezQt.Device.Modem : return "Modem"
            case BluezQt.Device.Network : return "Network"
            case BluezQt.Device.Headphones : return "Headphones"
            case BluezQt.Device.Headset  : return "Headset"
            case BluezQt.Device.AudioVideo : return "AudioVideo"
            case BluezQt.Device.Peripheral : return "Peripheral"
            case BluezQt.Device.camera : return "Camera"
            case BluezQt.Device.Printer : return "Printer"
            case BluezQt.Device.Imaging : return "Imaging"
            case BluezQt.Device.Wearable : return "Wearable"
            case BluezQt.Device.Toy : return "Toy"
            case BluezQt.Device.Health : return "Health"
            case BluezQt.Device.Joypad : return "Controller"
            case BluezQt.Device.Keyboard : return "Keyboard"
            case BluezQt.Device.Mouse : return "Mouse"
            case BluezQt.Device.Tablet : return "Tablet"
            case BluezQt.Device.Computer : return "Computer"
            case BluezQt.Device.Uncategorized : return "Unknown"
        }
    }
    
    // Convert to proper mac address format to filter out unnamed devices
    function filterBtDevice(device) {
        var name = device.name
        if(!name) return false
        return name.replace(/-/g, ":").toUpperCase() !== device.address.toUpperCase()
    }

    function isRelevantDevice(device) {
        return device.paired || (root.discovering && filterBtDevice(device))
    }

    function pairDevice(address) {
    var device = deviceForAddress(address)
    if (device) {
        device.pair()
    }
}

function pruneUnpairedDevices() {
    for (var i = devicesModel.count - 1; i >= 0; i--) {
        if (!devicesModel.get(i).paired) {
            devicesModel.remove(i)
        }
    }
}

Connections {
    target: root.manager.usableAdapter

    function onDiscoveringChanged(discovering) {
        if (!discovering) {
            pruneUnpairedDevices()
        }
    }
}
    

    Connections {
        target: root.manager

        function onOperationalChanged() {
            if (root.manager.operational) {
                devicesModel.clear()
                for (var i = 0; i < root.manager.devices.length; i++) {
                    if (isRelevantDevice(root.manager.devices[i])) {
                        addEntry(deviceToEntry(root.manager.devices[i]))
                    }
                }
            }
        }

        function onDeviceAdded(device) {
            if (isRelevantDevice(device) && indexOfDevice(device.address) === -1) {
                addEntry(deviceToEntry(device))
            }
        }

        function onDeviceRemoved(device) {
            var index = indexOfDevice(device.address)
            if(index !== -1) devicesModel.remove(index)
        }

        function onDeviceChanged(device) {
            var index = indexOfDevice(device.address)
            if (isRelevantDevice(device)) {
                var entry = deviceToEntry(device)
                if (index !== -1) {

                    var oldEntry = devicesModel.get(index)
                    var wasGroup = oldEntry.group
                    var wasConnected = oldEntry.connected

                    if (entry.group !== wasGroup) {
                        devicesModel.remove(index)
                        addEntry(entry)
                    } else {
                        devicesModel.set(index, entry)
                    }
                    if(entry.connected && !wasConnected) {
                        numberOfConnected++
                        console.log("Devices Connected: " + numberOfConnected)
                    } else if (!entry.connected && wasConnected && numberOfConnected > 0) {
                        numberOfConnected--
                        console.log("Devices Connected: " + numberOfConnected)
                    }

                } else {
                    addEntry(entry)
                }
            } else if (index !== -1) {
                devicesModel.remove(index)
            }
        }
    }
}