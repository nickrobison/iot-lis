//
//  DeviceEntity+Extensions.swift
//  LISManager
//
//  Created by Nicholas Robison on 10/27/20.
//

import Foundation
import LISKit

extension DeviceEntity {
    var connectionStatus: ConnectionStatus {
        get {
            return ConnectionStatus(rawValue: self.connectionStatusValue)!
        }
        set {
            self.connectionStatusValue = newValue.rawValue
        }
    }
    
    func toDevice() -> BluetoothDevice {
        return BluetoothDevice(id: self.deviceID!.uuidString, name: self.name!, status: self.connectionStatus)
    }
}
