//
//  ResultRow.swift
//  LISManager
//
//  Created by Nicholas Robison on 10/20/20.
//

import SwiftUI
import LISKit
import SRKit

struct ResultRow: View {
    
    let order: SRTestResult
    
    var formatter: DateFormatter {
        let date = DateFormatter()
        date.dateFormat = "E, d MMM - y h:mm a"
        return date
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(order.sampleType)
                buildImage().font(.subheadline)
            }.font(.subheadline)
            Text(formatter.string(from: order.dateTested)).font(.caption)
        }
    }
    
    private func buildImage() -> some View {
        if order.result == .negative {
            return Image(systemName: "minus.circle.fill").foregroundColor(.green)
        } else if order.result == .positive {
            return Image(systemName: "plus.circle.fill").foregroundColor(.red)
        } else {
            return Image(systemName: "questionmark.circle.fill").foregroundColor(.blue)
        }
    }
}

struct ResultRow_Previews: PreviewProvider {
    static var previews: some View {
        ResultRow(order: buildOrder())
    }

    private static func buildOrder() -> SRTestResult {
        return SRTestResult(id: UUID(), patientID: UUID(), sampleType: "CARS", dateTested: Date(), result: .positive)
    }
}
