//
//  DevicesView.swift
//  LISManager
//
//  Created by Nicholas Robison on 10/19/20.
//

import os
import LISKit
import SwiftUI
import Combine

struct DevicesView: View {
    private var bm = BluetoothManager()
    private var cancel: AnyCancellable?
    var devices: [BluetoothDevice]
    
    init(devices: [BluetoothDevice]) {
        self.devices = devices
    }
    
    
    @State private var showAdd = false
    var body: some View {
        NavigationView {
            Group {
                if devices.isEmpty {
                    Text("No registered devices")
                } else {
                    ForEach(devices) { device in
                        DeviceRow(device: device)
                    }
                }
            }
            .navigationBarItems(trailing:
                                    Button(action: {
                                        debugPrint("Hello from button click")
                                        os_log("Debug print logging")
                                        showAdd = true
                                    }, label: { Image(systemName: "plus")}))
            .sheet(isPresented: $showAdd, content: {
                DeviceAddView(discoveredDevices: bm.discoverDevices, handler: self.handleSelection)
            })
            
        }
        .navigationViewStyle(StackNavigationViewStyle()) // Temporary hack found via Reddit: https://www.reddit.com/r/SwiftUI/comments/ds5ku3/navigationview_rotation_bug_portrait_to_landscape/
        
    }
    
    private func handleSelection(_ deviceID: String) {
        self.showAdd = false
        bm.connect(toPeripheral: deviceID)
        
    }
}

struct DevicesView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            DevicesView(devices: [])
            DevicesView(devices: [BluetoothDevice(id: "111-2222-44545", name: "Test Device")])
        }
        
    }
}
