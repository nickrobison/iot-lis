//
//  DeviceRow.swift
//  LISManager
//
//  Created by Nicholas Robison on 10/19/20.
//

import LISKit
import SwiftUI

struct DeviceRow: View {
    
    let device: BluetoothDevice
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(device.name).font(.title)
            Text(device.id).font(.caption).padding([.leading])
        }
    }
}

struct DeviceRow_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            DeviceRow(device: BluetoothDevice(id: "hello", name: "1234"))
            DeviceRow(device: BluetoothDevice(id: UUID.init().uuidString, name: "This is a test device"))
        }
        
    }
}
