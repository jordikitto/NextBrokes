//
//  MockRemoveOldRacesUseCase.swift
//  FeatureRacing
//
//  Created by Jordi Kitto on 11/11/2024.
//

import Foundation
import FeatureRacingDomain

class MockRemoveOldRacesUseCase: RemoveOldRacesUseCaseProtocol {
    var hasBeenCalled = false
    var racesArg: [Race]?
    var result: [Race]!
    
    func callAsFunction(races: [Race]) -> [Race] {
        hasBeenCalled = true
        racesArg = races
        return result
    }
}
