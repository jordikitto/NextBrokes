//
//  FetchNextRacesUseCaseTests.swift
//  FeatureRacing
//
//  Created by Jordi Kitto on 10/11/2024.
//

import Testing
import FeatureRacingDomain
import Foundation

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
    
    @Test("Results with summaries that start at the same time")
    func resultsWithSummariesThatStartAtTheSameTime() async throws {
        // GIVEN repo returning results with summaries that start at the same time
        let sameDate = Date().addingTimeInterval(100)
        racingRepository.fetchNextRacesResult = .mock(
            nextToGoIds: ["3", "2", "1"],
            raceSummaries: [
                "1": .mock(raceId: "1", meetingName: "A", advertisedStartDate: sameDate),
                "2": .mock(raceId: "2", meetingName: "B", advertisedStartDate: sameDate),
                "3": .mock(raceId: "3", meetingName: "C")
            ]
        )
        
        // WHEN calling use case
        let sut = SUT(racingRepository: racingRepository)
        let result = try await sut(count: 5)
        
        // THEN result has three values, sorted by date then meeting name
        #expect(result.count == 3)
        #expect(result[0].id == "3")
        #expect(result[1].id == "1")
        #expect(result[2].id == "2")
    }
}
