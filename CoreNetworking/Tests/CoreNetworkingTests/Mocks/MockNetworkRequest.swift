//
//  MockNetworkRequest.swift
//  CoreNetworking
//
//  Created by Jordi Kitto on 10/11/2024.
//

import Foundation
@testable import CoreNetworking

struct MockNetworkRequest<R: Decodable>: NetworkRequestProtocol {
    typealias Response = R
    var path: String
    var parameters: [String: String?]
}
