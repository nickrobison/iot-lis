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
    
//    public static let sharedInstance = BluetoothManager()
    
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
    private var lisDevice: CBPeripheral?
    private let discoverSubject = PassthroughSubject<BluetoothDevice, Never>()
    
    
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
        lisDevice = periphs[0]
        lisDevice!.delegate = self
        connectionManager.connect(lisDevice!)
    }
    
    public func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        os_log("Discovered. ", log: logger, type: .debug)
//        connectionManager.stopScan()
        discoverSubject.send(BluetoothDevice(id: peripheral.identifier.uuidString, name: peripheral.name ?? "(unnamed)"))
        print(peripheral)
//        lisDevice = peripheral
//        connectionManager.connect(lisDevice!)
//        lisDevice!.delegate = self
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
        lisDevice!.discoverServices(nil)
    }
}

extension BluetoothManager : CBPeripheralDelegate {
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        os_log("Discovered services", log: logger, type: .debug)
        guard let services = peripheral.services else {
            return
        }
        
        for service in services {
            print("Service: \(service)")
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        os_log("Discovered characteristics for %s", log: logger, type: .debug, service.description)
        
        guard let characteristics = service.characteristics else {
            return
        }
        
        for characteristic in characteristics {
            print("Characteristic: \(characteristic)")
            if characteristic.properties.contains(.read) {
                print("\(characteristic.uuid): properties contains .read")
                //                peripheral.readValue(for: characteristic)
            }
            if characteristic.properties.contains(.notify) {
                print("\(characteristic.uuid): properties contains .notify")
                os_log("Subscribing to notify")
                peripheral.setNotifyValue(true, for: characteristic)
                
            }
            if characteristic.properties.contains(.write) {
                print("\(characteristic.uuid): properties contains .write")
                os_log("Begin write", log: logger, type: .debug)
                peripheral.writeValue("Hello Callie, love".data(using: .utf8)!, for: characteristic, type: .withResponse)
                os_log("Finished write", log: logger, type: .debug)
            }
        }
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
//        guard let _ = error else {
//            os_log("Error receiving from device: %s", log: logger, type: .error, error!.localizedDescription)
//            return
//        }
        guard let value = characteristic.value else {
            os_log("No value received from device", log: logger, type: .error)
            return
        }
        os_log("Message size: %d", log: logger, type: .debug, value.count)
        os_log("Received value: `%s`", log: logger, type: .debug, String(decoding: value, as: UTF8.self))
    }
}
