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
    public var connectionStatus: ConnectionStatus = .disconnected
    
    public init(id: String, name: String) {
        self.id = id
        self.name = name
    }
    
    public init(_ device: CBPeripheral) {
        self.id = device.identifier.uuidString
        self.name = device.name ?? "(unnamed)"
        self.device = device
    }
}
