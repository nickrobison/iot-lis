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
    @State private var showAdd = false
    
    init() {
        self.results = FetchRequest<OrderEntity>(entity: OrderEntity.entity(),
                                                 sortDescriptors: [NSSortDescriptor(keyPath:
                                                                                        \OrderEntity.orderID,
                                                                                    ascending: true)],
                                                 predicate: NSPredicate(format: "results.@count != 0"))
        
    }
    
    var body: some View {
        NavigationView {
            List(results.wrappedValue, id: \.self) { order in
                ResultRow(order: order)
            }
            .navigationBarTitle("Results")
            .navigationBarItems(trailing: Button(action: {
                debugPrint("Add result")
                self.showAdd = true
            }, label: {
                Image(systemName: "plus")
            }))
            .sheet(isPresented: self.$showAdd, content: {
                ResultsAddView()
            })
        }
    }
}
