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
            case loading(_ placeholderCount: Int)
            case loaded(_ races: [Race])
            case error(_ message: String)
        }
        
        enum Constant {
            static let loadLimit = 10
            static let displayLimit = 5
        }
        
        @Published private(set) var state: State = .loading(Constant.displayLimit)
        
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
                let races = try await fetchNextRaces(count: Constant.loadLimit)
                updateRaces(races)
            } catch {
                state = .error(error.localizedDescription)
            }
        }
        
        // MARK: - Private
        
        private func updateRaces(_ races: [Race]) {
            let displayRaces = Array(
                removeOldRaces(races: races)
                    .prefix(Constant.displayLimit)
            )
            
            state = .loaded(displayRaces)
            
            guard let firstRace = displayRaces.first else { return }
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
                    Task { [weak self] in
                        await self?.load()
                    }
                }
                .store(in: &bag)
        }
    }
}
