//
//  File.swift
//  LISManager
//
//  Created by Nicholas Robison on 10/22/20.
//

import Foundation
import Combine
import CoreData
import xxHash_Swift

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
    
    func toEntity(_ context: NSManagedObjectContext) -> PatientEntity {
        let entity = PatientEntity(context: context)
        entity.firstName = self.firstName
        entity.lastName = self.lastName
        entity.id = getID()
        return entity
    }
    
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
            .map{
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

    init() {
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
}
