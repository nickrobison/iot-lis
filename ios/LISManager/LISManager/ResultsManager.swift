//
//  ResultsManager.swift
//  LISManager
//
//  Created by Nicholas Robison on 10/23/20.
//

import Foundation
import CoreData
import Combine
import LISKit

class ResultsManager: ObservableObject {
    
    private let ctx: NSManagedObjectContext
    private let cancel: AnyCancellable?
    
    @Published var pub: String?
    
    init(ctx: NSManagedObjectContext) {
        self.ctx = ctx
        self.cancel = NotificationCenter.Publisher(center: .default, name: BluetoothManager.resultNotification, object: nil)
            .sink{
                let value = $0.object as! LIS_Protocols_TestResult
                let order = value.order!.toEntity(ctx)
                let result = value.results(at: 0)!.toEntity(ctx)
                order.results = [result]
                do {
                    try ctx.save()
                } catch {
                    debugPrint(error)
                }
            }
    }
    
    private func receiveValue(_ value: LIS_Protocols_Result) {
        
        
        // Send a notification
    }
}
