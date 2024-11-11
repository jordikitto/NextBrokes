//
//  NextRacesView.swift
//  NextBrokes
//
//  Created by Jordi Kitto on 9/11/2024.
//

import SwiftUI
import FeatureRacingPresentation
import CoreDesign

/// Displays the next to go races list.
struct NextRacesView: View {
    @StateObject private var viewModel = ViewModel()
    
    var body: some View {
        VStack(spacing: .zero) {
            HeaderView(title: String(localized: "Next to go racing"))
                .accessibilityAddTraits(.isHeader)
            NextRaceListView(
                displayLimit: 5,
                racingUseCaseFactory: viewModel.racingUseCaseFactory
            )
        }
    }
}
