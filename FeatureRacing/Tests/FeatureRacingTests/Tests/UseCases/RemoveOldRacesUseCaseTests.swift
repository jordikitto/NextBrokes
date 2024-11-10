//
//  Test.swift
//  FeatureRacing
//
//  Created by Jordi Kitto on 11/11/2024.
//

import Testing
import FeatureRacingDomain

@Suite("Remove Old Races Use Case")
struct RemoveOldRacesUseCaseTests {
    typealias SUT = RemoveOldRacesUseCase

    @Test("Returns empty if input is empty")
    func returnsEmptyIfInputIsEmpty() {
        // GIVEN no input races
        let sut = SUT()
        
        // WHEN calling use case
        let result = sut(races: [])
        
        // THEN result is empty
        #expect(result.isEmpty)
    }
    
    @Test("Returns races that begin after one mintue ago")
    func returnsRacesThatBeginAfterOneMinuteAgo() {
        // GIVEN races with various start dates
        let race1 = Race.mock(startDate: .now.addingTimeInterval(-120))
        let race2 = Race.mock(startDate: .now.addingTimeInterval(-60))
        let race3 = Race.mock(startDate: .now.addingTimeInterval(-30))
        let race4 = Race.mock(startDate: .now)
        let race5 = Race.mock(startDate: .now.addingTimeInterval(600))
        let races = [race1, race2, race3, race4, race5]
        
        // WHEN calling use case
        let sut = SUT()
        let result = sut(races: races)
        
        // THEN races that started one minute ago or later are not returned
        #expect(result == [race3, race4, race5])
    }
}
