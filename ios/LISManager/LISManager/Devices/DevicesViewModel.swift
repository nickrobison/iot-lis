//
//  DevicesViewModel.swift
//  LISManager
//
//  Created by Nicholas Robison on 10/19/20.
//

import Foundation
import LISKit
import Combine

class DevicesViewModel: ObservableObject {
    
    private let bm = BluetoothManager()
    
    @Published var registeredDevices: [BluetoothDevice] = []
    
    
    
    
    
}
