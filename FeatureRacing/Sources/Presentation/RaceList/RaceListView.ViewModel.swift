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
        
        let fetchNextRaces: FetchNextRacesUseCaseProtocol
        
        init(
            fetchNextRaces: FetchNextRacesUseCaseProtocol
        ) {
            self.fetchNextRaces = fetchNextRaces
        }
        
        func load() async {
            do {
                let races = try await fetchNextRaces(count: 5)
                state = .loaded(races)
            } catch {
                state = .error(error.localizedDescription)
            }
        }
    }
}
