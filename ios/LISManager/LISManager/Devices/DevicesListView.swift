//
//  DevicesListView.swift
//  LISManager
//
//  Created by Nicholas Robison on 10/20/20.
//

import SwiftUI
import LISKit

struct DevicesListView: View {
    
    public let devices: [BluetoothDevice]
    public var showStatus = true
    var body: some View {
        List(devices) {device in
            DeviceRow(device: device, showStatus: self.showStatus)
        }
    }
}

struct DevicesListView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            DevicesListView(devices: [])
            DevicesListView(devices: [
                BluetoothDevice(id: "1234", name: "Test Device"),
                BluetoothDevice(id: UUID.init().uuidString, name: "Test Device 2", status: .connected),
            ], showStatus: false)
            DevicesListView(devices: [
                BluetoothDevice(id: "1234", name: "Test Device"),
                BluetoothDevice(id: UUID.init().uuidString, name: "Test Device 2", status: .connected),
                BluetoothDevice(id: UUID.init().uuidString, name: "Test Device 3", status: .unknown),
                BluetoothDevice(id: UUID.init().uuidString, name: "Test Device 4", status: .error)
            ])
        }
        
    }
}
