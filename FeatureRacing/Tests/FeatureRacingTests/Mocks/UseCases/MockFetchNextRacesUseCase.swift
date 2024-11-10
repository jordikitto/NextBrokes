//
//  MockFetchNextRacesUseCase.swift
//  FeatureRacing
//
//  Created by Jordi Kitto on 11/11/2024.
//

import Foundation
import FeatureRacingDomain

class MockFetchNextRacesUseCase: FetchNextRacesUseCaseProtocol {
    var hasBeenCalled = false
    var countArg: Int?
    var error: Error?
    var result: [Race]!
    
    func callAsFunction(count: Int) async throws -> [Race] {
        hasBeenCalled = true
        countArg = count
        if let error = error {
            throw error
        }
        return result
    }
}
