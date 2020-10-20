//
//  ResultsViewModel.swift
//  LISManager
//
//  Created by Nicholas Robison on 10/20/20.
//

import Foundation
import Combine
import LISKit

struct DisplayResults : Hashable {
    let name: String
}

class ResultsViewModel : ObservableObject {
    @Published var results: [LIS_Protocols_TestResult] = []
    
    private var cancel: AnyCancellable?
    
    init(publisher: AnyPublisher<LIS_Protocols_TestResult, Never>) {
        self.cancel = publisher.sink(receiveValue: self.receiveResuls)
    }
    
    private func receiveResuls(result: LIS_Protocols_TestResult) {
        self.results.append(result)
    }
}
