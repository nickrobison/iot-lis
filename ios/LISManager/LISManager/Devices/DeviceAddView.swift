//
//  DeviceAddView.swift
//  LISManager
//
//  Created by Nicholas Robison on 10/19/20.
//

import SwiftUI
import LISKit
import Combine

struct DeviceAddView: View {
    
    
    let discoveredDevices: AnyPublisher<BluetoothDevice, Never>
    var handler: ((_ id: String) -> Void)?
    @State private var devices: [BluetoothDevice] = []
    
    var body: some View {
        VStack {
            Text("Select device to connect to:")
                .font(.title)
            Divider()
            ForEach(devices) {device in
                DeviceRow(device: device)
                    .onTapGesture {
                        debugPrint("Selected by tap: \(device)")
                        handler?(device.id)
                    }
            }
            Divider()
            Spacer()
            HStack {
                Text("Searching for devices...")
                ActivityIndicator(isAnimating: .constant(true), style: .medium, color: .gray)
            }
        }
        .padding()
        .onReceive(discoveredDevices, perform: { [self] device in
            self.devices.append(device)
        })
    }
}

struct DeviceAddView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            DeviceAddView(discoveredDevices: Just(BluetoothDevice(id: "Gopher-id", name: "Gopher")).eraseToAnyPublisher())
//            DeviceAddView(discoveredDevices: Empty().eraseToAnyPublisher())
        }
        
    }
}
