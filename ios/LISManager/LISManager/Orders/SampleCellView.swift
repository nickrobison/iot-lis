//
//  SampleCellView.swift
//  LISManager
//
//  Created by Nicholas Robison on 10/22/20.
//

import SwiftUI

struct OrderCellView: View {
    let sample: SampleEntity
    var body: some View {
        VStack {
            HStack {
                QRCodeView(msg: sample.cartridgeID!)
                Text("I'm a sample")
            }
            Divider()
            if sample.timer != nil {
                TimerView(timer: sample.timer!)
            } else {
                EmptyView()
            }
        }
        .border(Color.black)
    }
}

struct SampleCellView_Previews: PreviewProvider {
    static var previews: some View {
        OrderCellView(sample: sampleSample(isRunning: false))
    }
    
    static func sampleSample(isRunning: Bool) -> SampleEntity {
        let sample = SampleEntity()

        let timer = TimerEntity()
        timer.running = isRunning
        timer.duration = 15
        
        sample.timer = timer
        return sample
    }
}
