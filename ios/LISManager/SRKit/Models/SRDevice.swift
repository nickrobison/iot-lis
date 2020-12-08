//
//  SRDevice.swift
//  SRKit
//
//  Created by Nick Robison on 12/8/20.
//

import Foundation

public struct SRDevice: Identifiable {
    public let id: UUID
    public let manufacturer: String
    public let model: String
    public let loincCode: String
}
