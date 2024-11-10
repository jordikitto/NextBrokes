//
//  NetworkClient.swift
//  CoreNetworking
//
//  Created by Jordi Kitto on 9/11/2024.
//

import Foundation
import OSLog

public protocol NetworkClientProtocol: Sendable {
    func fetch<Request: NetworkRequestProtocol>(_ request: Request) async throws -> Request.Response
}

public struct NetworkClient: NetworkClientProtocol {
    let environment: NetworkEnvironment
    let decoder: JSONDecoder
    
    public init(
        environment: NetworkEnvironment,
        decoder: JSONDecoder
    ) {
        self.environment = environment
        self.decoder = decoder
    }
    
    public func fetch<Request: NetworkRequestProtocol>(_ request: Request) async throws -> Request.Response {
        guard let routeURL = request.url(environment: environment) else {
            throw NetworkError.invalidURL
        }
        
        Logger.network.info("Fetching: \(routeURL.absoluteString)")
        let (data, _) = try await URLSession.shared.data(from: routeURL)
        Logger.network.info("Fetched: \(routeURL.absoluteString)")
        
        return try decoder.decode(Request.Response.self, from: data)
    }
}

// MARK: - Extensions

private extension Logger {
    static let network = Logger(subsystem: "core.networking", category: "Network")
}
