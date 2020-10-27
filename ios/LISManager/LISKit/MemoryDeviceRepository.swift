//
//  MemoryDeviceRepository.swift
//  LISKit
//
//  Created by Nicholas Robison on 10/20/20.
//

import Foundation

public class MemoryDeviceRepository: DeviceRepository, ObservableObject {
    public typealias Device = BluetoothDevice
    
    public func getDevices() -> [Device] {
        return devices
    }
    
    @Published
    public var devices: [Device]
    
    init() {
        devices = []
    }
    
    public func getDevice(id: UUID) -> Device? {
        
        return devices.first {
            $0.id == id.uuidString
        }
    }
    
    public func addDevice(_ device: Device) {
        devices.append(device)
    }
    
    public func updateDeviceStatus(_ id: UUID, status: ConnectionStatus) {
        debugPrint("Setting status: \(status)")
        getDevice(id: id)?.connectionStatus = status
    }
    
    public func disconnectDevices() {
        // Ignore for now
    }
}
