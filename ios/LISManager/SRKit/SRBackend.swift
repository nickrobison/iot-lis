//
//  SRBackend.swift
//  SRKit
//
//  Created by Nick Robison on 12/2/20.
//

import Foundation
import PromiseKit

protocol SRBackend {
    
    func getPatients() -> Promise<[String]>
    
}
