//
//  BluetoothDevice+CBPeripheralDelegate.swift
//  LISKit
//
//  Created by Nicholas Robison on 10/20/20.
//

import os
import Foundation
import CoreBluetooth
import CoreData
import FlatBuffers

private let logger = OSLog(subsystem: "com.nickrobison.iot_list.LISManager.BluetoothManager", category: "device")

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
        
        // Try to read out the Flatbuffers value
        let echo = LIS_Protocols_TestResult.getRootAsTestResult(bb: ByteBuffer(data: value))
        os_log("Message size: %d", log: logger, type: .debug, value.count)
        let hdr = echo.header
        let ord = echo.order
        let cnt = echo.resultsCount
//        let nm = echo.results(at: 0)?.analyteName
        os_log("Received value: `%s`", log: logger, type: .debug, ord?.orderId ?? "(nothing)")
        self.resultsSubject.send(echo)
    }
}

