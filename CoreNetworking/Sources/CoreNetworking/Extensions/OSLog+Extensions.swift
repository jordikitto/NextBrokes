//
//  OSLog+Extensions.swift
//  CoreNetworking
//
//  Created by Jordi Kitto on 10/11/2024.
//

import Foundation
import OSLog

extension Logger {
    static let network = Logger(subsystem: "core.networking", category: "Network")
}
