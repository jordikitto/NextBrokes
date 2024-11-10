//
//  FetchNextRacesUseCase.swift
//  FeatureRacing
//
//  Created by Jordi Kitto on 9/11/2024.
//

import Foundation
import FeatureRacingData
import OSLog

public protocol FetchNextRacesUseCaseProtocol {
    func callAsFunction(count: Int) async throws -> [Race]
}

public struct FetchNextRacesUseCase: FetchNextRacesUseCaseProtocol {
    private let racingRepository: RacingRepositoryProtocol
    
    public init(racingRepository: RacingRepositoryProtocol) {
        self.racingRepository = racingRepository
    }
    
    public func callAsFunction(count: Int) async throws -> [Race] {
        let result = try await racingRepository.fetchNextRaces(count: count)
        
        let nextToGoIDs = result.nextToGoIds
        let raceSummaries = result.raceSummaries
        
        let raceSummariesSorted: [NetworkRacingRequest.RacingResult.RaceSummary] = nextToGoIDs.compactMap { id in
            guard let raceSummary = raceSummaries[id] else {
                Logger.fetchNextRaces.warning("Missing summary for id: \(id)")
                return nil
            }
            return raceSummary
        }
        
        return raceSummariesSorted.compactMap { raceSummary in
            do {
                return try .init(from: raceSummary)
            } catch {
                Logger.fetchNextRaces.error("Failed to create race from summary: \(raceSummary.raceId)")
                return nil
            }
        }
    }
}

extension Logger {
    static let fetchNextRaces = Logger(subsystem: "feature.racing", category: "FetchNextRaces")
}
