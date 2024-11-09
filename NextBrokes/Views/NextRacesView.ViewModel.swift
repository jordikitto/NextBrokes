//
//  NextRacesView.ViewModel.swift
//  NextBrokes
//
//  Created by Jordi Kitto on 9/11/2024.
//

import Foundation
import FeatureRacingDomain
import CoreNetworking

extension NextRacesView {
    final class ViewModel: ObservableObject {
        let racingUseCaseFactory: RacingUseCaseFactory
        
        init(
            networkClient: NetworkClientProtocol = DependencyContainer.shared.networkClient
        ) {
            self.racingUseCaseFactory = .init(
                racingRepository: RacingRepository(
                    networkClient: networkClient
                )
            )
        }
    }
}
