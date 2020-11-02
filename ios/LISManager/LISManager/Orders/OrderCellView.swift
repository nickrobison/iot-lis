//
//  OrderCellView.swift
//  LISManager
//
//  Created by Nicholas Robison on 10/22/20.
//

import SwiftUI

struct OrderCellView: View {
    let order: OrderEntity
    var body: some View {
        VStack {
            HStack {
                QRCodeView(msg: order.sample!.cartridgeID!)
                Text("I'm a sample")
            }
            Divider()
            if (order.timer != nil) {
                TimerView(timer: order.timer!)
            } else {
                EmptyView()
            }
        }
        .border(Color.black)
    }
}

struct OrderCellView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            OrderCellView(order: sampleOrder(isRunning: false))
            OrderCellView(order: sampleOrder(isRunning: true))
        }
    }

    static func sampleOrder(isRunning: Bool) -> OrderEntity {
        let e = OrderEntity()

        let s = SampleEntity()
        s.cartridgeID = "I'm a test cartridge"

        let t = TimerEntity()
        t.running = isRunning
        t.duration = 15

        e.timer = t
        e.sample = s
        return e
    }
}
