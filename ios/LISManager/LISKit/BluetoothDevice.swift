//
//  BluetoothDevice.swift
//  LISKit
//
//  Created by Nicholas Robison on 10/19/20.
//

import Foundation
import CoreBluetooth

public class BluetoothDevice : NSObject, Identifiable {
    public let id: String
    public let name: String
    public var device: CBPeripheral?
    public var connectionStatus: ConnectionStatus
    
    public init(id: String, name: String, status: ConnectionStatus = .disconnected) {
        self.id = id
        self.name = name
        self.connectionStatus = status
    }
    
    public init(_ device: CBPeripheral) {
        self.id = device.identifier.uuidString
        self.name = device.name ?? "(unnamed)"
        self.device = device
        self.connectionStatus = .disconnected
    }
}
