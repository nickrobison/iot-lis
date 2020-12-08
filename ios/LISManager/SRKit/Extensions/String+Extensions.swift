//
//  String+Extensions.swift
//  SRKit
//
//  Created by Nick Robison on 12/4/20.
//

import Foundation

extension String: LocalizedError {
    public var errorDescription: String? { return self }
}
