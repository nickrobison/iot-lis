//
//  ResultsView.swift
//  LISManager
//
//  Created by Nicholas Robison on 10/20/20.
//

import SwiftUI
import Combine

struct ResultsView: View {
    @ObservedObject var model: ResultsViewModel
    var body: some View {
        NavigationView {
            if model.results.isEmpty {
                Text("No results yet")
            } else {
                List(model.results, id: \.self) { result in
                    NavigationLink(
                        destination: ResultDetailView()){
                        ResultRow(result.order!.toOrderInformation())
                    }
                    
                }
            }
        }
    }
}

//struct ResultsView_Previews: PreviewProvider {
//    static var previews: some View {
//        Group {
//            ResultsView(model: ResultsViewModel(publisher: Just("Hello").eraseToAnyPublisher()))
//            ResultsView(model: ResultsViewModel(publisher: Empty().eraseToAnyPublisher()))
//        }
//
//    }
//}
