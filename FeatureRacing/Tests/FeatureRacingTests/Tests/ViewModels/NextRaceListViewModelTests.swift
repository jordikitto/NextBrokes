//
//  Test.swift
//  FeatureRacing
//
//  Created by Jordi Kitto on 11/11/2024.
//

import Testing
import Foundation
@testable import FeatureRacingPresentation
import FeatureRacingDomain

@MainActor
@Suite("NextRaceList ViewModel")
struct NextRaceListViewModelTests {
    typealias SUT = NextRaceListView.ViewModel
    
    let fetchNextRaces: MockFetchNextRacesUseCase
    let removeOldRaces: MockRemoveOldRacesUseCase
    let cleanupTrigger: MockDateTrigger
    
    init() {
        fetchNextRaces = .init()
        removeOldRaces = .init()
        cleanupTrigger = .init()
    }
    
    func makeSUT(
        displayLimit: Int = 5
    ) -> SUT {
        .init(
            displayLimit: displayLimit,
            fetchNextRaces: fetchNextRaces,
            removeOldRaces: removeOldRaces,
            cleanupTrigger: cleanupTrigger
        )
    }

    @Test("Initialises with correct default values")
    func testDefaultInitialisation() {
        // GIVEN init
        let sut = makeSUT(displayLimit: 3)
        
        // THEN values are as expected
        #expect(sut.state == .loading(3))
        #expect(sut.selectedCategories == Set(RaceCategory.allCases))
        #expect(sut.isFiltering == false)
    }

    @Test("Fetches valid races result successfully")
    func testFetchesValidRaces() async {
        let race1 = Race.mock()
        let race2 = Race.mock(startDate: .now.addingTimeInterval(10))
        let race3 = Race.mock()
        let race4 = Race.mock()
        
        // GIVEN valid init and return values
        let sut = makeSUT(displayLimit: 3)
        fetchNextRaces.result = [race1, race2, race3, race4]
        removeOldRaces.result = [race2, race3, race4]
        
        // WHEN load
        await sut.load()
        
        // THEN races loaded successfully
        #expect(sut.state == .loaded([race2, race3, race4]))
        #expect(sut.isFiltering == false)
        
        // THEN use cases called correctly
        #expect(fetchNextRaces.hasBeenCalled)
        #expect(fetchNextRaces.countArg == 6)
        #expect(removeOldRaces.hasBeenCalled)
        #expect(removeOldRaces.racesArg == [race1, race2, race3, race4])
        
        // THEN cleanup trigger setup correctly
        let expectedCleanupDate = race2.startDate.addingTimeInterval(60)
        #expect(cleanupTrigger.didCallSchedule)
        #expect(cleanupTrigger.scheduleDateArg?.formatted() == expectedCleanupDate.formatted())
    }
    
    @Test("Cleanup trigger firing removes old races")
    func testCleanupTriggerFiring() async throws {
        let race1 = Race.mock()
        let race2 = Race.mock()
        
        // GIVEN valid init and return values
        let sut = makeSUT(displayLimit: 2)
        fetchNextRaces.result = [race1, race2]
        removeOldRaces.result = [race1, race2]
        
        // WHEN load
        await sut.load()
        
        // THEN races loaded successfully
        #expect(sut.state == .loaded([race1, race2]))
        
        // WHEN cleanup trigger fires, and a race is now old
        removeOldRaces.result = [race2]
        try await change(of: sut.$state, expectedChangeCount: 1) {
            cleanupTrigger.fire()
        }
        
        // THEN races updated successfully
        #expect(sut.state == .loaded([race2]))
    }
    
    @Test("Filtering changes results")
    func testFiltering() async throws {
        let race1 = Race.mock(category: .greyhound)
        let race2 = Race.mock(category: .horse)
        let race3 = Race.mock(category: .harness)
        
        // GIVEN valid init and return values
        let sut = makeSUT(displayLimit: 3)
        fetchNextRaces.result = [race1, race2, race3]
        removeOldRaces.result = [race1, race2, race3]
        
        // WHEN load with filtering
        sut.selectedCategories = [.horse, .greyhound]
        await sut.load()
        
        // THEN only filter matching races are loaded
        #expect(sut.state == .loaded([race1, race2]))
        
        // WHEN filters are changed
        try await change(of: sut.$state, expectedChangeCount: 1) {
            sut.selectedCategories = [.harness]
        }
        
        // THEN only filter matching races are loaded
        #expect(sut.state == .loaded([race3]))
        
        // WHEN all filters are applied
        try await change(of: sut.$state, expectedChangeCount: 1) {
            sut.selectedCategories = []
        }
        
        // THEN this is an error state
        #expect(sut.state.isError)
        
        // WHEN all filters are removed
        try await change(of: sut.$state, expectedChangeCount: 1) {
            sut.selectedCategories = Set(RaceCategory.allCases)
        }
        
        // THEN all races are loaded
        #expect(sut.state == .loaded([race1, race2, race3]))
    }
    
    @Test("Error state is handled when fetch fails")
    func testErrorWhenFetching() async {
        // GIVEN valid init but returns error from fetch
        let sut = makeSUT()
        fetchNextRaces.error = NSError(domain: "", code: 1)
        
        // WHEN loading
        await sut.load()
        
        // THEN error state is set
        #expect(sut.state.isError)
    }
    
    @Test("Error state is handled when zero results returned")
    func testErrorWhenNoResults() async {
        // GIVEN valid init but returns zero results
        let sut = makeSUT()
        fetchNextRaces.result = []
        removeOldRaces.result = []
        
        // WHEN loading
        await sut.load()
        
        // THEN error state is set
        #expect(sut.state.isError)
    }
    
    @Test("Error state is handled when zero results after filtering")
    func testErrorWhenNoResultsAfterFiltering() async {
        let race = Race.mock()
        
        // GIVEN valid init but returns zero results after filtering
        let sut = makeSUT()
        fetchNextRaces.result = [race]
        removeOldRaces.result = []
        
        // WHEN loading
        await sut.load()
        
        // THEN error state is set
        #expect(sut.state.isError)
    }
    
    @Test("Error state is handled with invalid display limit")
    func testErrorWithInvalidDisplayLimit() {
        // GIVEN init with invalid display limit
        let sut = makeSUT(displayLimit: -1)
        
        // THEN error state is set
        #expect(sut.state.isError)
    }
}

// MARK: - Extensions

extension NextRaceListView.ViewModel.State {
    var isError: Bool {
        guard case .error = self else { return false }
        return true
    }
}
            
