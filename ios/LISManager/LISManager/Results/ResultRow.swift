//
//  ResultRow.swift
//  LISManager
//
//  Created by Nicholas Robison on 10/20/20.
//

import SwiftUI
import LISKit

struct ResultRow: View {
    
    let order: OrderEntity
    
    var formatter: DateFormatter {
        let date = DateFormatter()
        date.dateFormat = "E, d MMM - y h:mm a"
        return date
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(order.sampleType!)
                buildImage().font(.subheadline)
            }.font(.subheadline)
            Text(formatter.string(from: unwrapResult().resultDate!)).font(.caption)
        }
    }
    
    private func unwrapResult() -> ResultEntity {
        // swiftlint:disable:next force_cast
        let arry = self.order.results?.allObjects as! [ResultEntity]
        
        return arry.first!
    }
    
    private func buildImage() -> some View {
        let unwrapped = unwrapResult()
        if unwrapped.result! == "negative" {
            return Image(systemName: "minus.circle.fill").foregroundColor(.green)
        } else if unwrapped.result! == "positive" {
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

    private static func buildOrder() -> OrderEntity {
        let result = ResultEntity()
        result.result = "positive"
        result.resultDate = Date()
        let order = OrderEntity()
        order.addToResults(result)
        order.orderID = "O123A"
        order.sampleType = "SARS"
        return order
    }
}
