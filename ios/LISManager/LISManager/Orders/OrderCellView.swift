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
            if order.timer != nil {
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
        let order = OrderEntity()

        let sample = SampleEntity()
        sample.cartridgeID = "I'm a test cartridge"

        let timer = TimerEntity()
        timer.running = isRunning
        timer.duration = 15

        order.timer = timer
        order.sample = sample
        return order
    }
}
