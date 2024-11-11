//
//  FetchNextRacesUseCase.swift
//  FeatureRacing
//
//  Created by Jordi Kitto on 9/11/2024.
//

import Foundation
import FeatureRacingData
import OSLog

/// Protocol for use case that fetches upcoming races.
public protocol FetchNextRacesUseCaseProtocol {
    func callAsFunction(count: Int) async throws -> [Race]
}

/// Use case that fetches upcoming races.
///
/// Use to fetch upcoming races in a consistent, sorted order.
///
/// - Warning: Missing race summaries, or summaries that fail to initialise will be skipped.
public struct FetchNextRacesUseCase: FetchNextRacesUseCaseProtocol {
    private let racingRepository: RacingRepositoryProtocol
    
    public init(racingRepository: RacingRepositoryProtocol) {
        self.racingRepository = racingRepository
    }
    
    public func callAsFunction(count: Int) async throws -> [Race] {
        let result = try await racingRepository.fetchNextRaces(count: count)
        
        let nextToGoIDs = result.nextToGoIds
        let raceSummaries = result.raceSummaries
        
        // Map from ids list to summaries list
        let raceSummariesSorted: [NetworkRacingRequest.RacingResult.RaceSummary] = nextToGoIDs
            .compactMap { id in
                guard let raceSummary = raceSummaries[id] else {
                    Logger.fetchNextRaces.warning("Missing summary for id: \(id)")
                    return nil
                }
                return raceSummary
            }
        
        // Return successfully initialised, and sorted races.
        return raceSummariesSorted
            .compactMap { raceSummary in
                do {
                    return try .init(from: raceSummary)
                } catch {
                    Logger.fetchNextRaces.error("Failed to create race from summary: \(raceSummary.raceId)")
                    return nil
                }
            }
            // Additional sorting, to ensure consistent ordering for same start times
            .sorted(using: KeyPathComparator(\.meetingName))
            .sorted(using: KeyPathComparator(\.startDate))
    }
}

extension Logger {
    static let fetchNextRaces = Logger(subsystem: "feature.racing", category: "FetchNextRaces")
}
