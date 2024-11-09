//
//  RemoveOldRacesUseCase.swift
//  FeatureRacing
//
//  Created by Jordi Kitto on 9/11/2024.
//

import Foundation
import FeatureRacingData

public protocol RemoveOldRacesUseCaseProtocol {
    func callAsFunction(races: [Race]) -> [Race]
}

public struct RemoveOldRacesUseCase: RemoveOldRacesUseCaseProtocol {
    public init() {}
    
    public func callAsFunction(races: [Race]) -> [Race] {
        let oneMinuteAgoDate = Date().addingTimeInterval(-60)
        
        return races.filter { $0.startDate > oneMinuteAgoDate }
    }
}
