//
//  RaceTests.swift
//  FeatureRacing
//
//  Created by Jordi Kitto on 10/11/2024.
//

import Testing
import Foundation
@testable import FeatureRacingDomain
@testable import FeatureRacingData

@Suite("Race")
struct RaceTests {
    typealias SUT = Race

    @Test("Initialises from network response")
    func testInitFromNetworkResponse() throws {
        let startDate = Date.now.addingTimeInterval(10)
        let category = RaceCategory.harness
        
        // GIVEN network response
        let raceSummary = NetworkRacingRequest.RacingResult.RaceSummary.mock(
            category: category,
            advertisedStartDate: startDate
        )
        
        // WHEN initialise from network response
        let sut = try SUT(from: raceSummary)
        
        // THEN values as expected
        #expect(sut.id == raceSummary.raceId)
        #expect(sut.startDate.formatted() == startDate.formatted())
        #expect(sut.meetingName == raceSummary.meetingName)
        #expect(sut.raceNumber == raceSummary.raceNumber)
        #expect(sut.category == category)
    }

}
