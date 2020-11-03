//
//  OnboardingModel.swift
//  LISManager
//
//  Created by Nick Robison on 11/2/20.
//

import Foundation
import Combine

class OnboardingModel: ObservableObject {
    
    enum OnboardingState: CaseIterable {
        case initial
        case location
    }
    
    @Published var onboardingState: OnboardingState = .initial
    @Published var stateIdx = 0
    @Published var locationName = ""
    @Published var zipCode = ""
    @Published var buttonDisabled = false
    
    var completionHandler: ((ApplicationSettings) -> Void)?
    
    private var cancellableSet: Set<AnyCancellable> = []
    private var isButtonDisabledPublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest3(self.$onboardingState, stringNotEmpty(self.$locationName), Publishers.CombineLatest(stringNotEmpty(self.$zipCode), stringOnlyNumeric(self.$zipCode)).map { $0 && $1 })
            .map {
                // We only need to perform validation for the location field
                guard $0 == .location else {
                    return false
                }
                return !($1 && $2)
            }
            .eraseToAnyPublisher()
    }
    
    init(completionHandler: ((ApplicationSettings) -> Void)?) {
        self.completionHandler = completionHandler
        isButtonDisabledPublisher
            .receive(on: RunLoop.main)
            .assign(to: \.buttonDisabled, on: self)
            .store(in: &cancellableSet)
    }
    
    func handleClick() {
        if self.onboardingState == .location {
            self.updateSettings()
        } else {
            self.incrementState()
        }
    }
    
    private func updateSettings() {
        let settings = ApplicationSettings(zipCode: self.zipCode, locationName: self.locationName)
        self.completionHandler?(settings)
    }
    
    private func incrementState() {
        self.stateIdx += 1
        self.onboardingState = OnboardingModel.OnboardingState.allCases[self.stateIdx]
    }
}