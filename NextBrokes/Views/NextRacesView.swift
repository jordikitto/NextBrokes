//
//  NextRacesView.swift
//  NextBrokes
//
//  Created by Jordi Kitto on 9/11/2024.
//

import SwiftUI
import FeatureRacingPresentation

struct NextRacesView: View {
    @StateObject private var viewModel = ViewModel()
    
    var body: some View {
        RaceListView(
            racingUseCaseFactory: viewModel.racingUseCaseFactory
        )
        .padding(.horizontal)
    }
}
