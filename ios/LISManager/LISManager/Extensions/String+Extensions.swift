//
//  String+Extensions.swift
//  LISManager
//
//  Created by Nick Robison on 12/1/20.
//

import Foundation

/**
 Capitalize the first letter of the string
 */
extension String {
    func capitalizingFirstLetter() -> String {
        let first = self.prefix(1).capitalized
        let other = self.dropFirst()
        return first + other
    }
    
    mutating func capitalizingFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
