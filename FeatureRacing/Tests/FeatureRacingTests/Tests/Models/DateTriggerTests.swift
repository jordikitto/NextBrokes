//
//  DateTriggerTests.swift
//  FeatureRacing
//
//  Created by Jordi Kitto on 10/11/2024.
//

import Testing
import Combine
@testable import FeatureRacingDomain

@Suite("Date Trigger")
struct DateTriggerTests {
    typealias SUT = DateTrigger

    @Test("Does nothing when not scheduled")
    func testNotScheduled() async throws {
        var triggerCancellable: AnyCancellable?
        try await confirmation(expectedCount: 0) { confirm in
            // GIVEN trigger is not scheduled
            let sut = SUT()
            
            triggerCancellable = sut.triggerFired.sink { _ in
                confirm()
            }
            
            // WHEN next run loop is executed
            try await Task.sleep(nanoseconds: 1)
        }
        
        // THEN test passed since it was not confirmed
        triggerCancellable = nil
        #expect(triggerCancellable == nil)
    }
    
    @Test("Fires when scheduled")
    func testScheduled() async throws {
        var triggerCancellable: AnyCancellable?
        try await confirmation(expectedCount: 1) { confirm in
            // GIVEN trigger is scheduled
            let sut = SUT()
            
            triggerCancellable = sut.triggerFired.sink { _ in
                confirm()
            }
            
            // WHEN trigger is scheduled
            sut.schedule(.now.addingTimeInterval(0.1))
            
            try await Task.sleep(nanoseconds: 200_000_000)
        }
        
        // THEN test passed since it was confirmed
        triggerCancellable = nil
        #expect(triggerCancellable == nil)
    }
    
    @Test("Schedule can be overridden")
    func testOverride() async throws {
        var triggerCancellable: AnyCancellable?
        try await confirmation(expectedCount: 1) { confirm in
            // GIVEN trigger is scheduled
            let sut = SUT()
            
            triggerCancellable = sut.triggerFired.sink { _ in
                confirm()
            }
            
            // WHEN trigger is scheduled, but then scheduled again for later
            sut.schedule(.now.addingTimeInterval(0.1))
            sut.schedule(.now.addingTimeInterval(0.2))
            
            try await Task.sleep(nanoseconds: 500_000_000)
        }
        
        // THEN test passed since it was confirmed only once
        triggerCancellable = nil
        #expect(triggerCancellable == nil)
    }
}
