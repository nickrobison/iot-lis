//
//  SRMonitor.swift
//  LISManager
//
//  Created by Nick Robison on 12/6/20.
//

import Foundation
import SRKit
import CoreData
import Combine
import os

private let logger = OSLog(subsystem: "com.nickrobison.iot_list.LISManager", category: "monitor")

struct ResultWrapper {
    let patientHashedID: String
    let result: TestResultEnum
}

// This is a terrible hack for monitoring when ResultEntities get added and then submitting them to the GraphQL backend
class SRMonitor: ObservableObject {
    private let ctx: NSManagedObjectContext
    private let backend: SRBackend
    private var cancel: [AnyCancellable] = []
    
    private let resultSubject = PassthroughSubject<ResultWrapper, Never>()
    private let monitorQueue = DispatchQueue.init(label: "coreDataMonitor")
    private let uploadQueue = DispatchQueue.init(label: "resultUploadQueue")
    
    init(ctx: NSManagedObjectContext, backend: SRBackend) {
        self.ctx = ctx
        self.backend = backend
        self.start()
    }
    
    func start() {
        os_log("Starting SR Monitor", log: logger, type: .debug)
        NotificationCenter.default.publisher(for: .NSManagedObjectContextDidSave, object: ctx)
            .subscribe(on: self.monitorQueue)
            .filter { notification in
                notification.userInfo != nil
            }
            .map { notification in
                notification.userInfo!
            }
            .sink { userInfo in
                if let inserts = userInfo[NSInsertedObjectsKey] as? Set<NSManagedObject>, inserts.count > 0 {
                    for insert in inserts {
                        if let result = insert as? ResultEntity {
                            guard let patientID = result.patientHashedID else {
                                return
                            }
                            let resultEnum = TestResultEnum(rawValue: result.result!.uppercased())
                            self.resultSubject.send(ResultWrapper(patientHashedID: patientID, result: resultEnum!))
                        }
                    }
                }
            }.store(in: &self.cancel)
        
        self.resultSubject
            .subscribe(on: self.uploadQueue)
            .flatMap({ result -> AnyPublisher<Void, Never> in
                let subject = PassthroughSubject<Void, Never>()
                os_log("Received result to upload", log: logger, type: .debug)
                self.backend.add(result: .positive, on: Date(), to: result.patientHashedID).done { _ in
                    subject.send()
                }.catch { _ in
                    // Signal error, but keep going
//                    subject.send(completion: .failure(error))
                }
                return subject.eraseToAnyPublisher()
            })
            .sink(receiveValue: {
                // Done
            })
            .store(in: &self.cancel)
    }
}
