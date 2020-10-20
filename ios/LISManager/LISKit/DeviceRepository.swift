//
//  DeviceRepository.swift
//  LISKit
//
//  Created by Nicholas Robison on 10/20/20.
//

import Foundation

public protocol DeviceRepository : ObservableObject {
    var devices: [BluetoothDevice]{ get }
    func getDevice(id: UUID) -> BluetoothDevice?
    func addDevice(_ device: BluetoothDevice)
    func updateDeviceStatus(_ id: UUID, status: ConnectionStatus)
}
