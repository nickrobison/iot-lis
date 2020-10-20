//
//  MemoryDeviceRepository.swift
//  LISKit
//
//  Created by Nicholas Robison on 10/20/20.
//

import Foundation

public class MemoryDeviceRepository: DeviceRepository {
    
    private var registeredDevices: Dictionary<UUID, BluetoothDevice>
    
    init() {
        registeredDevices = [:]
    }
    
    public func getDevices() -> [BluetoothDevice] {
        return [BluetoothDevice](registeredDevices.values)
    }
    
    public func getDevice(id: UUID) -> BluetoothDevice? {
        return registeredDevices[id]
    }
    
    public func addDevice(_ device: BluetoothDevice) {
        registeredDevices[UUID.init(uuidString: device.id)!] = device
    }
    
    public func updateDeviceStatus(_ id: UUID, status: ConnectionStatus) {
        registeredDevices[id]?.connectionStatus = status
    }
}
