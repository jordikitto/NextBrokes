//
//  RacingRepository.swift
//  FeatureRacing
//
//  Created by Jordi Kitto on 9/11/2024.
//

import Foundation
import CoreNetworking
import FeatureRacingData

/// Protocol for a repository that fetches racing data.
public protocol RacingRepositoryProtocol {
    /// Fetches upcoming races.
    /// - Parameter count: Amount of upcoming races to fetch.
    func fetchNextRaces(count: Int) async throws -> NetworkRacingRequest.RacingResult
}

/// Repository that fetches racing data.
public struct RacingRepository: RacingRepositoryProtocol {
    private let networkClient: NetworkClientProtocol
    
    public init(
        networkClient: NetworkClientProtocol
    ) {
        self.networkClient = networkClient
    }
    
    public func fetchNextRaces(count: Int) async throws -> NetworkRacingRequest.RacingResult {
        let request = NetworkRacingRequest(method: .nextRaces, count: count)
        let result = try await networkClient.fetch(request)
        return result.data
    }
}
