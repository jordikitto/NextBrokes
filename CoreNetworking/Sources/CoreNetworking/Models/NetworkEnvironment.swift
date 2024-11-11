//
//  NetworkEnvironment.swift
//  CoreNetworking
//
//  Created by Jordi Kitto on 9/11/2024.
//

import Foundation

/// API environment configuration details.
public struct NetworkEnvironment: Sendable {
    /// Domain of the API. E.g. "https://www.example.com"
    let domain: String
    /// Base path of the API. E.g. "/api"
    let basePath: String
    
    public init(domain: String, basePath: String) {
        self.domain = domain
        self.basePath = basePath
    }
}
