//
//  NetworkClient.swift
//  CoreNetworking
//
//  Created by Jordi Kitto on 9/11/2024.
//

import Foundation

public protocol NetworkClientProtocol {
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
        guard let routeURL = environment.route(path: request.path) else {
            throw NetworkError.invalidURL
        }
        
        let (data, _) = try await URLSession.shared.data(from: routeURL)
        return try decoder.decode(Request.Response.self, from: data)
    }
}
