//
//  DevicesView.swift
//  LISManager
//
//  Created by Nicholas Robison on 10/19/20.
//

import os
import LISKit
import SwiftUI



struct DevicesView: View {
    static let bm = BluetoothManager()
    @ObservedObject private var repository = bm.deviceRepository
    
    @State private var showAdd = false
    var body: some View {
        NavigationView {
            Group {
                if repository.devices.isEmpty {
                    Text("No registered devices")
                } else {
                    DevicesListView(devices: repository.devices)
                }
            }
            .navigationBarItems(trailing:
                                    Button(action: {
                                        showAdd = true
                                    }, label: { Image(systemName: "plus")}))
            .sheet(isPresented: $showAdd, content: {
                DeviceAddView(discoveredDevices: DevicesView.bm.discoverDevices, handler: self.handleSelection)
            })
            
        }
    }
    
    private func handleSelection(_ deviceID: String) {
        self.showAdd = false
        DevicesView.bm.connect(toPeripheral: deviceID)
        
    }
}

struct DevicesView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            //            DevicesView(devices: [])
            //            DevicesView(devices: [BluetoothDevice(id: "111-2222-44545", name: "Test Device")])
        }
        
    }
}
