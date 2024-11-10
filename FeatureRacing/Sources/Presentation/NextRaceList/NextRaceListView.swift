//
//  NextRaceListView.swift
//  FeatureRacing
//
//  Created by Jordi Kitto on 9/11/2024.
//

import SwiftUI
import FeatureRacingDomain

public struct NextRaceListView: View {
    @StateObject private var viewModel: ViewModel
    
    public init(
        displayLimit: Int,
        racingUseCaseFactory: RacingUseCaseFactory
    ) {
        self._viewModel = .init(
            wrappedValue: .init(
                displayLimit: displayLimit,
                fetchNextRaces: racingUseCaseFactory.fetchNextRacesUseCase(),
                removeOldRaces: racingUseCaseFactory.removeOldRacesUserCase(),
                cleanupTrigger: DateTrigger()
            )
        )
    }
    
    public var body: some View {
        Self.Content(
            state: viewModel.state,
            selectedCategories: $viewModel.selectedCategories,
            isFiltering: viewModel.isFiltering
        )
        .task {
            await viewModel.load()
        }
    }
}
