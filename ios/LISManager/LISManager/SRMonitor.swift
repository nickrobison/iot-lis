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

// This is a terrible hack for monitoring when ResultEntities get added and then submitting them to the GraphQL backend
struct SRMonitor {
    private let ctx: NSManagedObjectContext
    private let backend: SRBackend
    private let cancel: AnyCancellable?
    
    init(ctx: NSManagedObjectContext, backend: SRBackend) {
        self.ctx = ctx
        self.backend = backend
        
        // Start the monitoring
        self.cancel = NotificationCenter.default.publisher(for: .NSManagedObjectContextDidSave, object: ctx)
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
                            // If we actually have a result entity, then we need to post it to the SRBackend
                            // TODO: Make this actually work, because it doesn't right now.
                            backend.add(result: .positive, on: result.resultDate!, to: patientID)
                        }
                    }
                }
            }
    }
}
