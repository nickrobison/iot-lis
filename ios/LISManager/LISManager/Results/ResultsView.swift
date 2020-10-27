//
//  ResultsView.swift
//  LISManager
//
//  Created by Nicholas Robison on 10/20/20.
//

import SwiftUI
import Combine

struct ResultsView: View {
    @FetchRequest(
        entity: OrderEntity.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \OrderEntity.orderID, ascending: true)]
    )
    var results: FetchedResults<OrderEntity>
    
    var body: some View {
        NavigationView {
            List(results, id: \.self) { order in
                ResultRow(order: order)
                //                NavigationLink(destination: ResultDetailView()) {
                ////                    ResultRow(order: result, result: result.results[0])
                //                }
            }
        }
    }
}
