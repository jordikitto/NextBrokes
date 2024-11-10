//
//  NextRacesView.swift
//  NextBrokes
//
//  Created by Jordi Kitto on 9/11/2024.
//

import SwiftUI
import FeatureRacingPresentation
import CoreDesign

struct NextRacesView: View {
    @StateObject private var viewModel = ViewModel()
    
    var body: some View {
        VStack(spacing: .zero) {
            HeaderView(title: "Next to go racing")
            RaceListView(
                racingUseCaseFactory: viewModel.racingUseCaseFactory
            )
            .padding(.horizontal)
        }
    }
}
