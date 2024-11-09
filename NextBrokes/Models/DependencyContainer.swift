//
//  DependencyContainer.swift
//  NextBrokes
//
//  Created by Jordi Kitto on 9/11/2024.
//

import Foundation
import CoreNetworking

final class DependencyContainer {
    static let shared = DependencyContainer()
    
    public let networkClient: NetworkClient
    
    private init() {
        self.networkClient = Self.initNetworkClient()
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
