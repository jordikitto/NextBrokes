//
//  RaceListView.ViewModel.swift
//  FeatureRacing
//
//  Created by Jordi Kitto on 9/11/2024.
//

import Foundation
import FeatureRacingDomain
import Combine

extension RaceListView {
    @MainActor
    final class ViewModel: ObservableObject {
        enum State: Equatable {
            case loading
            case loaded(_ races: [Race])
            case error(_ message: String)
        }
        
        @Published private(set) var state: State = .loading
        
        private let fetchNextRaces: FetchNextRacesUseCaseProtocol
        private let removeOldRaces: RemoveOldRacesUseCaseProtocol
        private let cleanupTrigger: DateTriggerable
        private var bag: Set<AnyCancellable> = []
        
        init(
            fetchNextRaces: FetchNextRacesUseCaseProtocol,
            removeOldRaces: RemoveOldRacesUseCaseProtocol,
            cleanupTrigger: any DateTriggerable
        ) {
            self.fetchNextRaces = fetchNextRaces
            self.removeOldRaces = removeOldRaces
            self.cleanupTrigger = cleanupTrigger
            
            bindCleanupRaces()
        }
        
        func load() async {
            do {
                let races = try await fetchNextRaces(count: 5)
                updateRaces(races)
            } catch {
                state = .error(error.localizedDescription)
            }
        }
        
        // MARK: - Private
        
        private func updateRaces(_ races: [Race]) {
            state = .loaded(races)
            
            guard let firstRace = races.first else { return }
            updateCleanupTrigger(firstRace: firstRace)
        }
        
        private func updateCleanupTrigger(firstRace: Race) {
            let oneMinuteAfterRaceEnds = firstRace.startDate.addingTimeInterval(60)
            cleanupTrigger.schedule(oneMinuteAfterRaceEnds)
        }
        
        private func bindCleanupRaces() {
            cleanupTrigger.triggerFired
                .receive(on: DispatchQueue.main)
                .sink { [weak self] in
                    self?.cleanupRaces()
                }
                .store(in: &bag)
        }
        
        private func cleanupRaces() {
            guard case let .loaded(races) = state else { return }
            let cleanedRaces = removeOldRaces(races: races)
            state = .loaded(cleanedRaces)
        }
    }
}
