//
//  MockDateTrigger.swift
//  FeatureRacing
//
//  Created by Jordi Kitto on 11/11/2024.
//

import Foundation
import FeatureRacingDomain
import Combine

class MockDateTrigger: DateTriggerable {
    private var triggerPublisher: PassthroughSubject<Void, Never> = .init()
    func fire() { triggerPublisher.send() }
    
    var triggerFired: AnyPublisher<Void, Never> {
        triggerPublisher.eraseToAnyPublisher()
    }
    
    var didCallSchedule = false
    var scheduleDateArg: Date?
    
    func schedule(_ date: Date) {
        didCallSchedule = true
        scheduleDateArg = date
    }
}
