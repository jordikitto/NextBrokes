//
//  RemoveOldRacesUseCase.swift
//  FeatureRacing
//
//  Created by Jordi Kitto on 9/11/2024.
//

import Foundation
import FeatureRacingData

/// Protocol for a use case that removes races that are considered old.
public protocol RemoveOldRacesUseCaseProtocol {
    func callAsFunction(races: [Race]) -> [Race]
}

/// Use case that removes old races, which is races that started more than 1 minute ago.
///
/// Use this to ensure consistent treatment and removal of races that are considered old.
public struct RemoveOldRacesUseCase: RemoveOldRacesUseCaseProtocol {
    public init() {}
    
    public func callAsFunction(races: [Race]) -> [Race] {
        let oneMinuteAgoDate = Date.now.addingTimeInterval(-60)
        
        return races.filter { $0.startDate > oneMinuteAgoDate }
    }
}
