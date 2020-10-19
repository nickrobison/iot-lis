//
//  FormValidationHelpers.swift
//  LISManager
//
//  Created by Nicholas Robison on 10/19/20.
//

import Foundation
import Combine


/**
 {Publisher} for determining whether or not the given string Publisher is returning an empty string.
 */
func stringNotEmpty(_ publisher: Published<String>.Publisher) -> AnyPublisher<Bool, Never> {
    publisher
        .debounce(for: 0.8, scheduler: RunLoop.main)
        .removeDuplicates()
        .map{ $0 != ""}
        .eraseToAnyPublisher()
}
