//
//  CoreDataDeviceRepository.swift
//  LISManager
//
//  Created by Nicholas Robison on 10/26/20.
//

import os
import Foundation
import LISKit
import CoreData

private let logger = OSLog(subsystem: "com.nickrobison.iot_list.LISManager.CoreDataDeviceRepository", category: "device")

class CoreDataDeviceRepository: DeviceRepository {
    
    private let ctx: NSManagedObjectContext
    private var loaded = false
    private var devices: [BluetoothDevice]
    
    init(ctx: NSManagedObjectContext) {
        self.ctx = ctx
        self.devices = []
    }
    
    func getDevice(id: UUID) -> BluetoothDevice? {
        let req = NSFetchRequest<DeviceEntity>(entityName: "DeviceEntity")
        req.predicate = NSPredicate(format: "deviceID = %@", id.uuidString)
        var device: BluetoothDevice?
        self.ctx.perform {
            device = try? self.ctx.fetch(req).first?.toDevice()
        }
        return device
    }
    
    func addDevice(_ device: BluetoothDevice) {
        self.ctx.perform {
            let entity = DeviceEntity(context: self.ctx)
            entity.connectionStatus = device.connectionStatus
            entity.deviceID = UUID.init(uuidString: device.id)
            entity.name = device.name
            do {
                try self.ctx.save()
                self.devices.append(device)
            } catch {
                os_log("Cannot save new device: %s", log: logger, type: .error, error.localizedDescription)
            }
        }
    }
    
    func updateDeviceStatus(_ id: UUID, status: ConnectionStatus) {
        let req = NSFetchRequest<DeviceEntity>(entityName: "DeviceEntity")
        req.predicate = NSPredicate(format: "deviceID = %@", id.uuidString)
        self.ctx.perform {
            guard let entity = try? self.ctx.fetch(req).first else {
                os_log("Cannot find device: %s", log: logger, type: .error, id.uuidString)
                return
            }
            
            entity.connectionStatus = status
            do {
                try self.ctx.save()
            } catch {
                os_log("Cannot update device: %s", log: logger, type: .error, error.localizedDescription)
            }
        }
    }
    
    func getDevices() -> [BluetoothDevice] {
        if self.loaded {
            return devices
        } else {
            loadDevices()
            return devices
        }
    }
    
    func disconnectDevices() {
        self.getDevices().forEach{ device in
            os_log("Disconnecting: %s", log: logger, type: .debug, device.id)
            self.updateDeviceStatus(UUID.init(uuidString: device.id)!, status: .disconnected)
        }
    }
    
    private func loadDevices() {
        let req = NSFetchRequest<DeviceEntity>(entityName: "DeviceEntity")
        self.ctx.perform {
            do {
                try self.ctx.fetch(req).forEach { device in
                    self.devices.append(device.toDevice())
                }
                self.loaded = true
            } catch {
                os_log("Cannot fetch devices", log: logger, type: .error)
            }
        }
    }
}
