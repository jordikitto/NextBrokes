//
//  FetchNextRacesUseCaseTests.swift
//  FeatureRacing
//
//  Created by Jordi Kitto on 10/11/2024.
//

import Testing
import FeatureRacingDomain

@Suite("Fetch Next Races Use Case")
struct FetchNextRacesUseCaseTests {
    typealias SUT = FetchNextRacesUseCase
    
    let racingRepository: MockRacingRepository
    
    init() {
        racingRepository = .init()
    }
    
    @Test("Empty results")
    func emptyResults() async throws {
        // GIVEN repo returning no results
        racingRepository.fetchNextRacesResult = .mock(
            nextToGoIds: [],
            raceSummaries: [:]
        )
        
        // WHEN calling use case
        let sut = SUT(racingRepository: racingRepository)
        let result = try await sut(count: 5)
        
        // THEN result is empty
        #expect(result.isEmpty)
    }

    @Test("Results with missing summaries")
    func resultsWithMissingSummaries() async throws {
        // GIVEN repo returning results with missing summaries
        racingRepository.fetchNextRacesResult = .mock(
            nextToGoIds: ["1", "2"],
            raceSummaries: ["2": .mock(raceId: "2")]
        )
        
        // WHEN calling use case
        let sut = SUT(racingRepository: racingRepository)
        let result = try await sut(count: 5)
        
        // THEN result has one value
        #expect(result.count == 1)
        #expect(result.first?.id == "2")
    }
    
    @Test("Results with all valid summaries")
    func resultsWithAllValidSummaries() async throws {
        // GIVEN repo returning results with all valid summaries
        racingRepository.fetchNextRacesResult = .mock(
            nextToGoIds: ["1", "2"],
            raceSummaries: [
                "1": .mock(raceId: "1"),
                "2": .mock(raceId: "2")
            ]
        )
        
        // WHEN calling use case
        let sut = SUT(racingRepository: racingRepository)
        let result = try await sut(count: 5)
        
        // THEN result has two values
        #expect(result.count == 2)
        #expect(result.first?.id == "1")
        #expect(result.last?.id == "2")
    }
}
