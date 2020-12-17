//
//  OnboardingModel.swift
//  LISManager
//
//  Created by Nick Robison on 11/2/20.
//

import Foundation
import Combine
import SRKit
import Apollo

class OnboardingModel: ObservableObject {
    
    enum OnboardingState: CaseIterable {
        case initial
        case user
        case location
    }
    
    @Published var onboardingState: OnboardingState = .initial
    @Published var stateIdx = 0
    @Published var locationName = ""
    @Published var zipCode = ""
    @Published var buttonDisabled = false
    @Published var user: ApplicationUser?
    @Published var facilities: [SRFacility] = []
    @Published var selectedFacilityID: UUID?
    
    var completionHandler: ((ApplicationSettings) -> Void)?
    
    private var cancellableSet: Set<AnyCancellable> = []
    private var isButtonDisabledPublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest3(self.$onboardingState,
                                  self.$selectedFacilityID,
//                                  stringNotEmpty(self.$locationName),
//                                  Publishers.CombineLatest(stringNotEmpty(self.$zipCode), stringOnlyNumeric(self.$zipCode))
//                                    .map { $0 && $1 },
                                    self.$user)
            .map {
                switch $0 {
                case .user:
                    return $2 == nil
                case .location:
                    return $1 == nil
//                    return !($1 && $2)
                default:
                    return false
                }
            }
            .eraseToAnyPublisher()
    }
    
    private let queue = DispatchQueue(label: "onboarding", qos: .userInteractive)
    private var client: ApolloClient?
    
    init(completionHandler: ((ApplicationSettings) -> Void)?) {
        self.completionHandler = completionHandler
        isButtonDisabledPublisher
            .receive(on: RunLoop.main)
            .assign(to: \.buttonDisabled, on: self)
            .store(in: &cancellableSet)
    }
    
    func fetchFacilities(connect to: String, for organization: UUID) {
        self.client = ApolloClient(url: URL.init(string: to)!)
        self.client?.fetch(query: GetFacilitiesQuery()) { [weak self] result in
            switch result {
            case .success(let resData):
                debugPrint("I have things")
                if let facilities = resData.data?.organization?.testingFacility {
                    self?.facilities = facilities.filter { $0 != nil }
                        .map { $0!.toSRFacility()}
                }
            case .failure(let error):
                debugPrint("An error: \(error)")
            }
        }
    }
    
    func handleClick() {
        if self.onboardingState == .location {
            self.updateSettings()
        } else {
            self.incrementState()
        }
    }
    
    private func updateSettings() {
        let settings = ApplicationSettings(zipCode: self.zipCode, locationName: self.locationName, backendURI: URL(string: "http://127.0.0.1:8080/graphql")!, user: self.user!, facilityID: self.selectedFacilityID!)
        self.completionHandler?(settings)
    }
    
    private func incrementState() {
        self.stateIdx += 1
        self.onboardingState = OnboardingModel.OnboardingState.allCases[self.stateIdx]
    }
}
