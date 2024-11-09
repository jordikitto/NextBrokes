//
//  NedsNetworkEnvironment.swift
//  NextBrokes
//
//  Created by Jordi Kitto on 9/11/2024.
//

import Foundation
import CoreNetworking

extension NetworkEnvironment {
    static let neds = NetworkEnvironment(
        domain: "https://api.neds.com.au",
        basePath: "/rest/v1"
    )
}
