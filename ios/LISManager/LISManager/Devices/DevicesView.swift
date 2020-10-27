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
    @EnvironmentObject var bm: BluetoothManager
    
    @FetchRequest(
        entity: DeviceEntity.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \DeviceEntity.name, ascending: true)]
    )
    var devices: FetchedResults<DeviceEntity>
    
    @State private var showAdd = false
    var body: some View {
        NavigationView {
            Group {
                if devices.isEmpty {
                    Text("No registered devices")
                } else {
                    List(devices) { device in
                        DeviceRow(device: device.toDevice(), showStatus: true)
                    }
                }
            }
            .navigationBarItems(trailing:
                                    Button(action: {
                                        self.showAdd = true
                                    }, label: { Image(systemName: "plus")}))
            .sheet(isPresented: $showAdd, content: {
                DeviceAddView(discoveredDevices: self.bm.discoverDevices, handler: self.handleSelection)
            })
            
        }
    }
    
    private func handleSelection(_ deviceID: String) {
        self.showAdd = false
        self.bm.connect(toPeripheral: deviceID)
        
    }
}

//struct DevicesView_Previews: PreviewProvider {
//    static var previews: some View {
//        Group {
//            //            DevicesView(devices: [])
//            //            DevicesView(devices: [BluetoothDevice(id: "111-2222-44545", name: "Test Device")])
//        }
//
//    }
//}
