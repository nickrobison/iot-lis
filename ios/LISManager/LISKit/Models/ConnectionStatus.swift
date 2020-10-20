//
//  ConnectionStatus.swift
//  LISKit
//
//  Created by Nicholas Robison on 10/19/20.
//

import Foundation

public enum ConnectionStatus: Int16, CaseIterable {
    case connected
    case disconnected
    case unknown
}
