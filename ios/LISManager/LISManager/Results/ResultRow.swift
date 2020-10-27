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
        let d = DateFormatter()
        d.dateFormat = "E, d MMM - y h:mm a"
        return d
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
        let arry = self.order.results?.allObjects as! [ResultEntity]
        
        return arry.first!
    }
    
    private func buildImage() -> some View {
        let r = unwrapResult()
        if r.result! == "negative" {
            return Image(systemName: "minus.circle.fill").foregroundColor(.green)
        } else if r.result! == "positive" {
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
        let r = ResultEntity()
        r.result = "positive"
        r.resultDate = Date()
        let o = OrderEntity()
        o.addToResults(r)
        o.orderID = "O123A"
        o.sampleType = "SARS"
        return o
    }
}
