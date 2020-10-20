//
//  ResultRow.swift
//  LISManager
//
//  Created by Nicholas Robison on 10/20/20.
//

import SwiftUI
import LISKit

struct ResultRow: View {
    
    private let result: OrderInformation
    
    init(_ result: OrderInformation) {
        self.result = result
    }
    var body: some View {
        VStack(alignment: .leading) {
            Text(result.orderID).font(.title)
            Text(result.testType).padding([.leading])
        }
    }
}

struct ResultRow_Previews: PreviewProvider {
    static var previews: some View {
        ResultRow(OrderInformation(orderID: "123-424", testType: "Covid2"))
    }
}
