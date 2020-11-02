//
//  BluetoothDevice.swift
//  LISKit
//
//  Created by Nicholas Robison on 10/19/20.
//

import os
import Foundation
import CoreBluetooth
import FlatBuffers

private let logger = OSLog(subsystem: "com.nickrobison.iot_list.LISManager.BluetoothDevice", category: "device")

public class BluetoothDevice: NSObject, Identifiable {
    public let id: String
    public let name: String
    public var device: CBPeripheral?
    public var connectionStatus: ConnectionStatus
    
    private var buffer: Data
    
    public init(id: String, name: String, status: ConnectionStatus = .disconnected) {
        self.id = id
        self.name = name
        self.connectionStatus = status
        self.buffer = Data()
    }
    
    public init(_ device: CBPeripheral) {
        self.id = device.identifier.uuidString
        self.name = device.name ?? "(unnamed)"
        self.device = device
        self.connectionStatus = .disconnected
        self.buffer = Data()
    }
}

extension BluetoothDevice: CBPeripheralDelegate {
    
    public func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        
        guard error == nil else {
            os_log("Error receiving from device: %s", log: logger, type: .error, error!.localizedDescription)
            return
        }
        guard let value = characteristic.value else {
            os_log("No value received from device", log: logger, type: .error)
            return
        }
        os_log("Received %d bytes of data", log: logger, type: .error, value.count)
        
        // Look to see if the first byte of data matches the EOT byte, if not, keep adding away
        guard value.first! == UInt8(4) else {
            self.buffer.append(value)
            return
        }
        
        let decompressed = try? (self.buffer as NSData).decompressed(using: .lzma)
        // Reset the buffer
        self.buffer = Data()
        
        guard let d2 = decompressed else {
            os_log("Unable to decompress input stream", log: logger, type: .error)
            return
        }
        
        // Try to read out the Flatbuffers value
        let echo = LIS_Protocols_TestResult.getRootAsTestResult(bb: ByteBuffer(data: d2 as Data))
        os_log("Message size: %d", log: logger, type: .debug, value.count)
        let ord = echo.order
        os_log("Received value: `%s`", log: logger, type: .debug, ord!.testTypeName!)
        NotificationCenter.default.post(name: BluetoothManager.resultNotification, object: echo)
    }
    
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
}
