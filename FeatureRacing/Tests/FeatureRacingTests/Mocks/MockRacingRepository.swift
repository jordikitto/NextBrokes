//
//  MockRacingRepository.swift
//  FeatureRacing
//
//  Created by Jordi Kitto on 10/11/2024.
//

import Foundation
import FeatureRacingData
import FeatureRacingDomain

final class MockRacingRepository: RacingRepositoryProtocol {
    var didCallFetchNextRaces = false
    var fetchNextRacesCountArg: Int?
    var fetchNextRacesError: Error?
    var fetchNextRacesResult: NetworkRacingRequest.RacingResult!
    
    func fetchNextRaces(count: Int) async throws -> NetworkRacingRequest.RacingResult {
        didCallFetchNextRaces = true
        fetchNextRacesCountArg = count
        if let fetchNextRacesError {
            throw fetchNextRacesError
        }
        return fetchNextRacesResult
    }
}
