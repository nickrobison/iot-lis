//
//  LISDeviceEntity+ConnectionStatus.swift
//  LISKit
//
//  Created by Nicholas Robison on 10/19/20.
//

import Foundation

extension LISDeviceEntity {
    var connectionStatus: ConnectionStatus {
        get {
            return ConnectionStatus(rawValue: self.connectionStatusValue)!
        }
        set {
            self.connectionStatusValue = newValue.rawValue
        }
    }
}
