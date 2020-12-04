//
//  ResultsView.swift
//  LISManager
//
//  Created by Nicholas Robison on 10/20/20.
//

import SwiftUI
import Combine
import SRKit

struct ResultsView: View {
    @Environment(\.srBackend) private var backend
    @State private var results: [SRTestResult] = []
    @State private var showAdd = false
    
    var body: some View {
        NavigationView {
            Group {
                if results.count == 0 {
                    Text("No results yet")
                } else {
                    List(results) { result in
                        ResultRow(order: result)
                    }
                }
            }
            .navigationBarTitle("Results")
            .navigationBarItems(trailing: Button(action: {
                debugPrint("Add result")
                self.showAdd = true
            }, label: {
                Image(systemName: "plus")
            }))
            .sheet(isPresented: self.$showAdd, content: {
                ResultsAddView()
            })
        }
        .onReceive(self.backend.getResults().assertNoFailure(), perform: { result in
            self.results.append(result)
        })
    }
}
