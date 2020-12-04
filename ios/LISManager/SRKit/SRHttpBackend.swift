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
        df.dateFormat = "yyyy-MM-dd"
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
    
    public func getResults() -> AnyPublisher<SRTestResult, Error> {
        let publisher = PassthroughSubject<SRTestResult, Error>()
        
        self.client.fetch(query: TestResultListQuery()) { result in
            switch result {
            case .success(let data):
                guard let results = data.data?.testResults else {
                    publisher.send(completion: .finished)
                    return
                }
                results.filter {
                    $0 != nil
                }.map {
                    $0!.toSRTestResult()
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
}
