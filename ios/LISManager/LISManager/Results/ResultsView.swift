//
//  ResultsView.swift
//  LISManager
//
//  Created by Nicholas Robison on 10/20/20.
//

import SwiftUI
import Combine

struct ResultsView: View {
    var results: FetchRequest<OrderEntity>
    
    init() {
        self.results = FetchRequest<OrderEntity>(entity: OrderEntity.entity(),
                                                 sortDescriptors: [NSSortDescriptor(keyPath:
                                                                                        \OrderEntity.orderID,
                                                                                    ascending: true)],
                                                 predicate: NSPredicate(format: "results.@count != 0"))
        
    }
    
    var body: some View {
        NavigationView {
            if results.wrappedValue.count == 0 {
                Text("No results yet")
            } else {
                List(results.wrappedValue, id: \.self) { order in
                    ResultRow(order: order)
                }
            }
        }
    }
}
