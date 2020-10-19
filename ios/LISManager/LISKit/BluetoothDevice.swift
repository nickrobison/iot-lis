//
//  BluetoothDevice.swift
//  LISKit
//
//  Created by Nicholas Robison on 10/19/20.
//

import Foundation

public struct BluetoothDevice : Identifiable {
    public let id: String
    public let name: String
    
    public init(id: String, name: String) {
        self.id = id
        self.name = name
    }
}
