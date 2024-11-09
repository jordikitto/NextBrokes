//
//  NetworkEnvironment.swift
//  CoreNetworking
//
//  Created by Jordi Kitto on 9/11/2024.
//

import Foundation

public struct NetworkEnvironment: Sendable {
    let domain: String
    let basePath: String
    
    public init(domain: String, basePath: String) {
        self.domain = domain
        self.basePath = basePath
    }
    
    public func route(path: String) -> URL? {
        URL(string: domain + basePath + path)
    }
}
