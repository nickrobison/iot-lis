//
//  SRHttpBackend.swift
//  SRKit
//
//  Created by Nick Robison on 12/2/20.
//

import Foundation
import Apollo
import PromiseKit

struct SRHttpBackend: SRBackend {
    
    private let client: ApolloClient
    
    init(connect to: String) {
        self.client = ApolloClient(url: URL.init(string: to)!)
    }
    
    func getPatients() -> Promise<[String]> {
        let promise = Promise<[String]> { seal in
            self.client.fetch(query: PatientListQuery()) { result in
                switch result {
                case .success(let resData):
                    guard let patients = resData.data?.patients else {
                        seal.fulfill([])
                        return
                    }
                    
                    let ids = patients.filter { patient in
                        patient != nil
                    }.map { patient in
                        String(patient!.internalId!.utf8)
                    }
                    seal.fulfill(ids)
                case .failure(let error):
                    seal.reject(error)
                }
            }
        }
        
        return promise
    }
}
