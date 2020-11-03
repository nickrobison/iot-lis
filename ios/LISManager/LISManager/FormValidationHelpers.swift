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
        .debounce(for: 0.2, scheduler: RunLoop.main)
        .removeDuplicates()
        .map { $0 != ""}
        .eraseToAnyPublisher()
}

/**
 {Publisher} for determining whether or not the given string contains only digits
 */
func stringOnlyNumeric(_ publisher: Published<String>.Publisher) -> AnyPublisher<Bool, Never> {
    publisher
        .debounce(for: 0.2, scheduler: RunLoop.main)
        .removeDuplicates()
        .map {
            CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: $0))
        }
        .eraseToAnyPublisher()
}
