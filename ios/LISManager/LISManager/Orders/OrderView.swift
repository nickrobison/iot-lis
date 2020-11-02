//
//  OrderView.swift
//  LISManager
//
//  Created by Nicholas Robison on 10/22/20.
//

import SwiftUI

struct OrderView: View {
    
    @FetchRequest(
        entity: OrderEntity.entity(),
        sortDescriptors: []
        //        sortDescriptors: [
        //            NSSortDescriptor(keyPath: \SampleEntity.cartridgeID, ascending: true)]
    )
    var orders: FetchedResults<OrderEntity>
    
    var body: some View {
        NavigationView {
            if (orders.count == 0) {
                Text("No orders yet")
            } else {
                List(orders, id: \.self) { order in
                    OrderCellView(order: order)
                }
            }
        }
    }
}

struct OrderView_Previews: PreviewProvider {
    static var previews: some View {
        OrderView()
    }
}
