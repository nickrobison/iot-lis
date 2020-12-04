//
//  SRHttpBackend.swift
//  SRKit
//
//  Created by Nick Robison on 12/2/20.
//

import Foundation
import Apollo
import Combine

public struct SRHttpBackend: SRBackend {
    
    private let client: ApolloClient
    private let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyy-MM-dd"
        return df
    }()
    
    public init(connect to: String) {
        self.client = ApolloClient(url: URL.init(string: to)!)
    }
    
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
                    self.toSRPerson(patient: $0!)
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
    
    private func toSRPerson(patient: PatientListQuery.Data.Patient) -> SRPerson {
        let id = String(patient.internalId!.utf8)
        let birthDate = self.dateFormatter.date(from: patient.birthDate!)!
        
        return SRPerson(id: UUID(uuidString: id)!, firstName: patient.firstName!, lastName: patient.lastName!,
                        birthday: birthDate,
                        street: patient.street!,
                        street2: patient.streetTwo!,
                        city: patient.city!,
                        state: patient.state!,
                        zip: patient.zipCode!,
                        gender: patient.gender!)
    }
}
