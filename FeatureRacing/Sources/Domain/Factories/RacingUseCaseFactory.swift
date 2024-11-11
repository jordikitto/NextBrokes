//
//  RacingUseCaseFactory.swift
//  FeatureRacing
//
//  Created by Jordi Kitto on 9/11/2024.
//

import Foundation

/// Factory to wrap the creation of use cases related to racing.
public struct RacingUseCaseFactory {
    private let racingRepository: RacingRepositoryProtocol
    
    public init(racingRepository: RacingRepositoryProtocol) {
        self.racingRepository = racingRepository
    }
    
    public func fetchNextRacesUseCase() -> FetchNextRacesUseCase {
        .init(racingRepository: racingRepository)
    }
    
    public func removeOldRacesUserCase() -> RemoveOldRacesUseCase {
        .init()
    }
}
