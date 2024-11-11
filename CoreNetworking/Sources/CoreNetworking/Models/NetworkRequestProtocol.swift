//
//  NetworkRequestProtocol.swift
//  CoreNetworking
//
//  Created by Jordi Kitto on 9/11/2024.
//

import Foundation

/// Protocol for a network request, with base properties required for a request.
public protocol NetworkRequestProtocol {
    /// Type of the response expected from the request.
    associatedtype Response: Decodable
    /// Path to the endpoint.
    var path: String { get }
    /// Parameters to be added to the request.
    var parameters: [String: String?] { get }
}

extension NetworkRequestProtocol {
    /// ``parameters`` as an array of URLQueryItems.
    var parameterQueryItems: [URLQueryItem] {
        parameters
            .compactMapValues { $0 }
            .map { .init(name: $0.key, value: $0.value) }
    }
    
    /// Fully formed URL for the request.
    func url(environment: NetworkEnvironment) -> URL? {
        guard let url = URL(string: environment.domain + environment.basePath + path) else {
            return nil
        }
        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            return nil
        }
        
        // Add parameters, if any
        let queryItems = parameterQueryItems
        if !queryItems.isEmpty {
            urlComponents.queryItems = queryItems
        }
        
        return urlComponents.url
    }
}
