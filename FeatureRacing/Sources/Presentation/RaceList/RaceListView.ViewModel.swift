//
//  RaceListView.ViewModel.swift
//  FeatureRacing
//
//  Created by Jordi Kitto on 9/11/2024.
//

import Foundation
import FeatureRacingDomain

extension RaceListView {
    final class ViewModel: ObservableObject {
        enum State: Equatable {
            case loading
            case loaded(_ races: [Race])
            case error(_ message: String)
        }
        
        @Published private(set) var state: State = .loading
    }
}
