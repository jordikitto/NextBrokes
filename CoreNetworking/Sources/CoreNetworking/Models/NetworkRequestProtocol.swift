//
//  NetworkRequestProtocol.swift
//  CoreNetworking
//
//  Created by Jordi Kitto on 9/11/2024.
//

import Foundation

public protocol NetworkRequestProtocol {
    associatedtype Response: Decodable
    
    var path: String { get }
    var headers: [String: String?] { get }
}

extension NetworkRequestProtocol {
    var queryItems: [URLQueryItem] {
        headers
            .compactMapValues { $0 }
            .map { .init(name: $0.key, value: $0.value) }
    }
    
    func url(environment: NetworkEnvironment) -> URL? {
        guard let url = URL(string: environment.domain + environment.basePath + path) else {
            return nil
        }
        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            return nil
        }
        urlComponents.queryItems = queryItems
        return urlComponents.url
    }
}
