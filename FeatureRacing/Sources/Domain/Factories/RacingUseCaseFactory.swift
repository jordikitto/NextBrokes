//
//  RacingUseCaseFactory.swift
//  FeatureRacing
//
//  Created by Jordi Kitto on 9/11/2024.
//

import Foundation

public struct RacingUseCaseFactory {
    private let racingRepository: RacingRepositoryProtocol
    
    public init(racingRepository: RacingRepositoryProtocol) {
        self.racingRepository = racingRepository
    }
    
    public func fetchNextRacesUseCase() -> FetchNextRacesUseCase {
        .init(racingRepository: racingRepository)
    }
}
