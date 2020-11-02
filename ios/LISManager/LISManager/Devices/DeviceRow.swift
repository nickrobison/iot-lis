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
    var showStatus = false
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(device.name).font(.title)
                if showStatus {
                    getImage().opacity(device.connectionStatus == .disconnected ? 0 : 1)
                }
            }
            Text(device.id).font(.caption).padding([.leading])
        }
        .foregroundColor(getColor())
    }
    
    private func getImage() -> some View {
        switch device.connectionStatus {
        case .connected:
            return Image(systemName: "checkmark.circle.fill")
                .font(.subheadline)
                .foregroundColor(.green)
        case .disconnected:
            return Image(systemName: "checkmark.circle.fill")
                .font(.subheadline)
                .foregroundColor(.green)
        case .unknown:
            return Image(systemName: "questionmark.circle.fill")
                .font(.subheadline)
                .foregroundColor(.orange)
        case .error:
            return Image(systemName: "exclamationmark.circle.fill")
                .font(.subheadline)
                .foregroundColor(.red)
        }
    }
    
    private func getColor() -> Color {
        if showStatus && device.connectionStatus == .disconnected {
            return .gray
        }
        return .primary
    }
}

struct DeviceRow_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            DeviceRow(device: BluetoothDevice(id: "1234-2124-23323", name: "hello"), showStatus: false)
            DeviceRow(device: BluetoothDevice(id: UUID.init().uuidString, name: "Disconnected device"))
            DeviceRow(device: BluetoothDevice(id: UUID.init().uuidString, name: "Disconnected device"))
            DeviceRow(device: BluetoothDevice(id: UUID.init().uuidString, name: "Connected device", status: .connected))
            DeviceRow(device: BluetoothDevice(id: UUID.init().uuidString, name: "Unknown device", status: .unknown))
            DeviceRow(device: BluetoothDevice(id: UUID.init().uuidString, name: "Error device", status: .error))
        }
        
    }
}
