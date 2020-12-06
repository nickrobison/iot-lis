//
//  SRHttpBackend.swift
//  SRKit
//
//  Created by Nick Robison on 12/2/20.
//

import Foundation
import Apollo
import Combine
import PromiseKit

public struct SRHttpBackend: SRBackend {

    private let client: ApolloClient
    private let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        return df
    }()
    
    private let patientSubject = PassthroughSubject<SRPerson, Error>()
    
    public init(connect to: String) {
        self.client = ApolloClient(url: URL.init(string: to)!)
    }
    
    // MARK: - Patient Methods
    
    public func getPatients() -> AnyPublisher<SRPerson, Error> {
        let publisher = PassthroughSubject<SRPerson, Error>()
        self.client.fetch(query: PatientListQuery()) { result in
            switch result {
            case .success(let resData):
                guard let patients = resData.data?.patients else {
                    publisher.send(completion: .finished)
                    return
                }
                patients.filter { patient in
                    patient != nil
                }.map {
                    $0!.toSRPerson()
                }.forEach {
                    publisher.send($0)
                }
                publisher.send(completion: .finished)
            case .failure(let error):
                publisher.send(completion: .failure(error))
            }
        }
        return publisher.eraseToAnyPublisher()
    }
    
    // swiftlint:disable:next function_parameter_count line_length
    public func addPatient(externalID: String, firstName: String, lastName: String, birthDate: Date, street: String, street2: String, city: String, state: String, zipCode: String, county: String, gender: String) -> Promise<SRPerson> {
        return Promise<SRPerson> { seal in
            // swiftlint:disable:next line_length
            self.client.perform(mutation: AddPatientMutation.init(id: externalID, firstName: firstName, lastName: lastName, middleName: "", suffix: "", birthDate: birthDate.toGraphQLDate(), street: street, street2: street2, city: city, state: state, zipCode: zipCode, county: county, email: "", telephone: "555-555-5555", race: "", ethnicity: "", gender: "", role: "", employedInHealthcare: false, residentCongregateSetting: false)) { result in
                
                switch result {
                case .failure(let error):
                    seal.reject(error)
                case .success:
                    let id = UUID()
                    //                    let id = UUID.init(uuidString: data.data!.addPatient!)
                    // swiftlint:disable:next line_length
                    let patient = SRPerson(id: id, firstName: firstName, lastName: lastName, birthday: birthDate, street: street, street2: street2, city: city, state: state, zip: zipCode, gender: gender, orders: [], results: [])
                    
                    // Let's go ahead and add the new person to the cache
                    // This is a hacky workaround for now. Ideally, we would return the GraphQL entity itself, but that might be more work than it's worth.
                    DispatchQueue.global(qos: .background).async {
                        self.client.store.withinReadWriteTransaction { transaction in
                            do {
                                try self.updatePersonCache(patient: patient, id: id, transaction: transaction, seal: seal)
                            } catch {
                                seal.reject(error)
                            }
                        }
                        
                        seal.fulfill(patient)
                    }
                }
            }
        }
    }
    
    public func getResults() -> AnyPublisher<SRTestResult, Error> {
        let subject = PassthroughSubject<SRTestResult, Error>()
        self.client.fetch(query: TestResultListQuery()) { result in
            switch result {
            case .success(let data):
                guard let results = data.data?.testResults else {
                    subject.send(completion: .finished)
                    return
                }
                results.filter {
                    $0 != nil
                }.map {
                    $0!.toSRTestResult()
                }.forEach {
                    debugPrint("Sending along")
                    subject.send($0)
                }
                subject.send(completion: .finished)
            case .failure(let error):
                subject.send(completion: .failure(error))
                
            }
        }
        
        return subject.eraseToAnyPublisher()
    }
    
    // MARK: - Order methods
    
    // MARK: - Result methods
    
    private func updatePersonCache(patient: SRPerson, id: UUID, transaction: ApolloStore.ReadWriteTransaction, seal: Resolver<SRPerson>) throws {
        let query = PatientListQuery()
        try transaction.update(query: query) {(data: inout PatientListQuery.Data) in
            // swiftlint:disable:next line_length
            let gqlPatient = PatientListQuery.Data.Patient(internalId: GraphQLID(id.uuidString), firstName: patient.firstName, lastName: patient.lastName, birthDate: patient.birthday.toGraphQLDate(), street: patient.street, streetTwo: patient.street2, city: patient.city, state: patient.state, zipCode: patient.zip, gender: patient.gender)
            data.patients?.append(gqlPatient)
        }
        seal.fulfill(patient)
    }
}
