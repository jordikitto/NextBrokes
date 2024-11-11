//
//  DependencyContainer.swift
//  NextBrokes
//
//  Created by Jordi Kitto on 9/11/2024.
//

import Foundation
import CoreNetworking

/// A container for dependencies used throughout the app.
final class DependencyContainer {
    static let shared = DependencyContainer()
    
    /// NEDS API client.
    public let nedsNetworkClient: NetworkClient
    
    private init() {
        self.nedsNetworkClient = Self.initNetworkClient()
    }

    private static func initNetworkClient() -> NetworkClient {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        
        return .init(
            environment: .neds,
            decoder: jsonDecoder
        )
    }
}
