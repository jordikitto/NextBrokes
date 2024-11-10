//
//  MockNetworkEnvironment.swift
//  CoreNetworking
//
//  Created by Jordi Kitto on 10/11/2024.
//

import Foundation
@testable import CoreNetworking

extension NetworkEnvironment {
    static func mock(
        domain: String = "https://www.mock.com",
        basePath: String = "/api"
    ) -> NetworkEnvironment {
        .init(
            domain: domain,
            basePath: basePath
        )
    }
}
