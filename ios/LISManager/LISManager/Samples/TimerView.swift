//
//  TimerView.swift
//  LISManager
//
//  Created by Nicholas Robison on 10/23/20.
//

import SwiftUI

struct TimerView: View {
    
    let timer: TimerEntity
    var body: some View {
        HStack {
            Text("Timer")
            buildImage()
            Text("15:00")
        }
    }
    
    private func buildImage() -> some View {
        if timer.running {
            return Image(systemName: "stopwatch.fill").foregroundColor(.orange)
        }
        return Image(systemName: "stopwatch").foregroundColor(.primary)
    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView(timer: buildTimer(isRunning: true))
    }
    
    private static func buildTimer(isRunning: Bool) -> TimerEntity {
        let t = TimerEntity()
        t.running = isRunning
        t.duration = 15
        return t
    }
}
