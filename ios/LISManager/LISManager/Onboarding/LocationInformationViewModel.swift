//
//  LocationInformationViewModel.swift
//  LISManager
//
//  Created by Nicholas Robison on 10/19/20.
//

import Foundation
import Combine

class LocationInformationViewModel: ObservableObject {
    @Published var locationName = ""
    @Published var locationPostalCode = ""
    @Published var isValid = false
    
    private var cancellableSet: Set<AnyCancellable> = []
    private var locCancel: AnyCancellable?
    
    private var formIsValidPublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest(stringNotEmpty(self.$locationName), stringNotEmpty(self.$locationPostalCode))
            .map {
                $0 && $1
            }
            .eraseToAnyPublisher()
    }
    
    private let lm = LocationManager()
    
    init() {
        formIsValidPublisher
            .receive(on: RunLoop.main)
            .assign(to: \.isValid, on: self)
            .store(in: &cancellableSet)
        
        locCancel = lm.$postalCode
            .sink(receiveCompletion: { _ in
                print("completed")
            }, receiveValue: { [weak self] val in
                self?.locationPostalCode = val
            })
    }
}
