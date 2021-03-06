//
//  File.swift
//  LISManager
//
//  Created by Nicholas Robison on 10/22/20.
//

import Foundation
import Combine
import xxHash_Swift
import SRKit
import PromiseKit

struct PatientModel {
    let firstName: String
    let lastName: String
    let gender: String
    let sex: String
    let birthday: Date
    let address1: String
    let address2: String
    let city: String
    let state: String
    let zipCode: String
    
    func getID() -> String {
        let idString = self.firstName + self.lastName + self.zipCode
        return XXH32.digestHex(idString)
    }
}

class PatientAddModel: ObservableObject {
    private static let today = Date()
    // Name
    @Published var firstName = ""
    @Published var lastName = ""
    
    // Demographics
    @Published var gender = ""
    @Published var sex = ""
    @Published var birthday = today
    
    // Address
    @Published var address1 = ""
    @Published var address2 = ""
    @Published var city = ""
    @Published var state = ""
    @Published var zipCode = ""
    
    @Published var isValid = false
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    private var isFormValidPublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest3(isNameValid, isDemographicsValidPublisher, isAddressValidPublisher)
            .map {
                $0 && $1 && $2
            }
            .eraseToAnyPublisher()
    }
    
    private var isNameValid: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest(stringNotEmpty(self.$firstName), stringNotEmpty(self.$lastName))
            .map {
                $0 && $1
            }
            .eraseToAnyPublisher()
    }
    
    private var isDemographicsValidPublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest(stringNotEmpty(self.$gender), stringNotEmpty(self.$sex))
            .map {
                $0 && $1
            }
            .eraseToAnyPublisher()
    }
    
    private var isDateValidPublisher: AnyPublisher<Bool, Never> {
        return self.$birthday
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .removeDuplicates()
            .map {
                $0 != PatientAddModel.today
            }
            .eraseToAnyPublisher()
    }
    
    private var isAddressValidPublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest4(stringNotEmpty(self.$address1), stringNotEmpty(self.$city),
                                  stringNotEmpty(self.$state), stringNotEmpty(self.$zipCode))
            .map {
                $0 && $1 && $2 && $3
            }
            .eraseToAnyPublisher()
    }
    
    private var backend: SRBackend
    
    init(backend: SRBackend) {
        self.backend = backend
        isFormValidPublisher
            .receive(on: RunLoop.main)
            .assign(to: \.isValid, on: self)
            .store(in: &cancellableSet)
    }
    
    func toModel() -> PatientModel {
        PatientModel(firstName: self.firstName, lastName: self.lastName,
                     gender: self.gender, sex: self.sex, birthday: self.birthday,
                     address1: self.address1, address2: self.address2, city: self.city,
                     state: self.state, zipCode: self.zipCode)
    }
    
    func submitPatient() -> Promise<SRPerson> {
        // swiftlint:disable:next line_length
        return self.backend.addPatient(externalID: "", firstName: self.firstName, lastName: self.lastName, birthDate: self.birthday, street: self.address1, street2: self.address2, city: self.city, state: self.state, zipCode: self.zipCode, county: "", gender: self.gender)
    }
}
