//
//  MemoryDeviceRepository.swift
//  LISKit
//
//  Created by Nicholas Robison on 10/20/20.
//

import Foundation

public class MemoryDeviceRepository: DeviceRepository {
    @Published
    public var devices: [BluetoothDevice]
    
    init() {
        devices = []
    }
    
    public func getDevice(id: UUID) -> BluetoothDevice? {
        
        return devices.first {
            $0.id == id.uuidString
        }
    }
    
    public func addDevice(_ device: BluetoothDevice) {
        devices.append(device)
    }
    
    public func updateDeviceStatus(_ id: UUID, status: ConnectionStatus) {
        debugPrint("Setting status: \(status)")
        getDevice(id: id)?.connectionStatus = status
    }
}
