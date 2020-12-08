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
import os

private let logger = OSLog(subsystem: "com.nickrobison.iot_list.LISManager.SRKit", category: "HTTPBackend")

public class SRHttpBackend: SRBackend {

    private let client: ApolloClient
    private let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        return df
    }()
    
    private let patientSubject = PassthroughSubject<SRPerson, Error>()
    private var deviceMap: [String: UUID] = [:]
    
    public init(connect to: String) {
        self.client = ApolloClient(url: URL.init(string: to)!)
        
        // Populate the device map
        self.getDevices().done { devices in
            for device in devices {
                os_log("Adding device: '%s' to map.", log: logger, type: .debug, device.model)
                self.deviceMap[device.model] = device.id
            }
        }
    }
    
    // MARK: - Patient Methods
    
    public func getPatients() -> Promise<[SRPerson]> {
        Promise<[SRPerson]> { seal in
            self.client.fetch(query: PatientListQuery()) { result in
                switch result {
                case .success(let resData):
                    guard let patients = resData.data?.patients else {
                        seal.fulfill([])
                        return
                    }
                    let people = patients.filter { patient in
                        patient != nil
                    }.map {
                        $0!.toSRPerson()
                    }
                    seal.fulfill(people)
                case .failure(let error):
                    seal.reject(error)
                }
            }
        }
    }
    
    public func subscribeToPatient() -> AnyPublisher<SRPerson, Error> {
        let publisher = PassthroughSubject<SRPerson, Error>()
        self.getPatients().done { result in
            result.forEach { patient in
                publisher.send(patient)
            }
            publisher.send(completion: .finished)
        }.catch { error in
            publisher.send(completion: .failure(error))
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
    
    public func addPatientToQueue(id: UUID) -> Promise<Void> {
        return Promise<Void> { seal in
            self.client.perform(mutation: AddPatientToQueueMutation(id: id.uuidString, symptoms: "{}qq", firstTest: false, noSymptoms: true)) { result in
                switch result {
                case .success:
                    seal.fulfill(())
                case .failure(let error):
                    seal.reject(error)
                }
            }
        }
    }
    
    // MARK: - Order methods
    
    // MARK: - Result methods
    
    public func getResults() -> Promise<[SRTestResult]> {
        return Promise<[SRTestResult]> { seal in
            self.client.fetch(query: TestResultListQuery()) { result in
                switch result {
                case .success(let data):
                    guard let results = data.data?.testResults else {
                        seal.fulfill([])
                        return
                    }
                    let filtered = results.filter {
                        $0 != nil
                    }.map {
                        $0!.toSRTestResult()
                    }
                    seal.fulfill(filtered)
                case .failure(let error):
                    seal.reject(error)
                }
            }
        }
    }
    
    public func subscribeToResults() -> AnyPublisher<SRTestResult, Error> {
        let subject = PassthroughSubject<SRTestResult, Error>()
        
        self.getResults().done { results in
            for result in results {
                subject.send(result)
            }
            subject.send(completion: .finished)
        }.catch { error in
            subject.send(completion: .failure(error))
        }
        
        return subject.eraseToAnyPublisher()
    }

    public func add(result: TestResultEnum, on date: Date, to hashedPatientID: String) -> Promise<Void> {
        return Promise<Void> { seal in
            self.getPatients()
                .done { patients in
                    guard let patient = patients.filter({ $0.hashedID == hashedPatientID}).first else {
                        seal.fulfill(())
                        return
                    }
                    
                    // Get the ID of the device we're testing
                    guard let deviceID = self.deviceMap["Sofia 2 SARS Antigen FIA"] else {
                        seal.reject("Cannot find test device")
                        return
                    }
                    
                    self.client.perform(mutation: AddTestResultMutation(DeviceID: deviceID.uuidString, Result: result.rawValue, PatientID: patient.id.uuidString)) { result in
                        switch result {
                        case .success:
                            seal.fulfill(())
                        case .failure(let error):
                            seal.reject(error)
                        }
                    }
                }
        }
    }
    
    // MARK: - Device methods
    
    public func getDevices() -> Promise<[SRDevice]> {
        return Promise<[SRDevice]> { seal in
            self.client.fetch(query: DeviceListQuery()) { result in
                switch result {
                case .success(let data):
                    guard let devices = data.data?.deviceType else {
                        seal.fulfill([])
                        return
                    }
                    seal.fulfill(devices.map({ $0!.toSRDevice() }))
                case .failure(let error):
                    seal.reject(error)
                }
            }
        }
    }

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
