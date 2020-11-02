//
//  DeviceRepository.swift
//  LISKit
//
//  Created by Nicholas Robison on 10/20/20.
//

import Foundation

public protocol DeviceRepository {
    func getDevice(id: UUID) -> BluetoothDevice?
    func addDevice(_ device: BluetoothDevice)
    func updateDeviceStatus(_ id: UUID, status: ConnectionStatus)
    func getDevices() -> [BluetoothDevice]
    func disconnectDevices()
}
