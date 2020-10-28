//
//  BluetoothManager.swift
//  LISKit
//
//  Created by Nicholas Robison on 10/18/20.
//

import os
import Foundation
import CoreBluetooth
import Combine

private let logger = OSLog(subsystem: "com.nickrobison.iot_list.LISManager.BluetoothManager", category: "bluetooth")

public class BluetoothManager : NSObject, CBCentralManagerDelegate, ObservableObject {
    
    public static let resultNotification = Notification.Name("ResultNotification")
    
    public var discoverDevices: AnyPublisher<BluetoothDevice, Never> {
        discoverSubject
            .handleEvents(receiveSubscription: { _ in
                os_log("Starting subscription", log: logger, type: .debug)
                self.connectionManager.scanForPeripherals(withServices: [self.iotListUUID])
                
            }, receiveCancel: { [weak self] in
                os_log("Received cancel", log: logger, type: .debug)
                self?.connectionManager.stopScan()
            })
            .eraseToAnyPublisher()
    }
    
    private let connectionManager = CBCentralManager()
    private let iotListUUID = CBUUID(string: "00010000-0001-1000-8000-00805F9B34FB")
    private let discoverSubject = PassthroughSubject<BluetoothDevice, Never>()
    
    public var deviceRepository: DeviceRepository = MemoryDeviceRepository()
    
    
    public override init() {
        super.init()
        os_log("Initializing Bluetooth Manager", log: logger, type: .debug)
        connectionManager.delegate = self
    }
    
    public func connect(toPeripheral deviceID: String) {
        os_log("Connecting to peripheral with ID: %s", log: logger, type: .debug, deviceID)
        let periphs = connectionManager.retrievePeripherals(withIdentifiers: [UUID.init(uuidString: deviceID)!])
        if periphs.isEmpty {
            return
        }
        let periph = periphs[0]
        periph.delegate = self
        let device = BluetoothDevice(periph)
        deviceRepository.addDevice(device)
//        let device = LISDeviceEntity.create(fromPeripheral: periph)
//        deviceMap[device.id!] = device
        connectionManager.connect(periph)
    }
    
    public func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        os_log("Discovered. ", log: logger, type: .debug)
        discoverSubject.send(BluetoothDevice(id: peripheral.identifier.uuidString, name: peripheral.name ?? "(unnamed)"))
        print(peripheral)
    }
    
    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
        os_log("Changing state", log: logger, type: .debug)
        switch central.state {
        case .unknown:
            os_log("No idea what's going on", log: logger, type: .debug)
        case .resetting:
            os_log("Resetting", log: logger, type: .debug)
        case .unsupported:
            os_log("Unsupported", log: logger, type: .error)
        case .unauthorized:
            os_log("Unauthorized", log: logger, type: .error)
        case .poweredOff:
            os_log("Powered off", log: logger, type: .debug)
        case .poweredOn:
            os_log("Powered on", log: logger, type: .debug)
//            connectionManager.scanForPeripherals(withServices: [iotListUUID])
        @unknown default:
            fatalError("Unknown state \(central.state)")
        }
    }
    
    public func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        os_log("Connected to %s", log: logger, type: .debug, peripheral.name ?? "(unnamed)")
        deviceRepository.updateDeviceStatus(peripheral.identifier, status: ConnectionStatus.connected)
        peripheral.discoverServices(nil)
    }
    
    public func shutdown() {
        os_log("Performing shutdown actions", log: logger, type: .debug)
        self.deviceRepository.disconnectDevices()
    }
    
    public func reconnect() {
        os_log("Reconnecting devices", log: logger, type: .debug)
        self.deviceRepository.getDevices().forEach { device in
            os_log("Reconnecting to device: %s", log: logger, type: .debug, device.id)
            self.connect(toPeripheral: device.id)
        }
    }
}
