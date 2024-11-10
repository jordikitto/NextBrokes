//
//  NextRaceListView.ViewModel.swift
//  FeatureRacing
//
//  Created by Jordi Kitto on 9/11/2024.
//

import Foundation
import FeatureRacingDomain
import Combine
import OSLog

extension NextRaceListView {
    @MainActor
    final class ViewModel: ObservableObject {
        enum State: Equatable {
            case loading(_ placeholderCount: Int)
            case loaded(_ races: [Race])
            case error(_ message: String)
            
            var isLoading: Bool {
                guard case .loading = self else { return false }
                return true
            }
        }
        
        enum Constant {
            static let loadRatio = 2
        }
        
        @Published private(set) var state: State
        @Published var selectedCategories = Set(RaceCategory.allCases)
        
        var isFiltering: Bool {
            selectedCategories.count != RaceCategory.allCases.count
        }
        
        private let raceDisplayLimit: Int
        private let fetchNextRaces: FetchNextRacesUseCaseProtocol
        private let removeOldRaces: RemoveOldRacesUseCaseProtocol
        private let cleanupTrigger: DateTriggerable
        
        private var allRaces: [Race]?
        private var bag: Set<AnyCancellable> = []
        
        init(
            displayLimit: Int,
            fetchNextRaces: FetchNextRacesUseCaseProtocol,
            removeOldRaces: RemoveOldRacesUseCaseProtocol,
            cleanupTrigger: any DateTriggerable
        ) {
            self.raceDisplayLimit = displayLimit
            self.fetchNextRaces = fetchNextRaces
            self.removeOldRaces = removeOldRaces
            self.cleanupTrigger = cleanupTrigger
            
            if displayLimit > 0 {
                self._state = .init(initialValue: .loading(displayLimit))
            } else {
                self._state = .init(initialValue: .error("Invalid display limit"))
            }
            
            bindCleanupRaces()
            bindFiltering()
        }
        
        func load() async {            
            do {
                let races = try await fetchNextRaces(count: raceDisplayLimit * Constant.loadRatio)
                allRaces = races
                updateRaces(races)
            } catch {
                Logger.raceListViewModel.error("Failed to load: \(error)")
                state = .error("An error occurred.\nPlease try again later.")
            }
        }
        
        // MARK: - Private
        
        private func updateRaces(_ races: [Race]) {
            // Only want races that are "upcoming"
            let upcomingRaces = removeOldRaces(races: races)
            
            // Run cleanup based on next upcoming race
            if let firstUpcomingRace = upcomingRaces.first {
                updateCleanupTrigger(firstRace: firstUpcomingRace)
            }
            
            // Only want races that match filters
            let filteredRaces = upcomingRaces.filter { selectedCategories.contains($0.category) }
            
            // Ensure we have at least one race to show now
            guard !filteredRaces.isEmpty else {
                if isFiltering {
                    state = .error("No races match current filters. Please change filters.")
                } else {
                    state = .error("No races currently available. Please try again later.")
                }
                return
            }
            
            // Only display a limited amount of races
            let displayRaces = Array(filteredRaces.prefix(raceDisplayLimit))
            state = .loaded(displayRaces)
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
        
        private func bindFiltering() {
            $selectedCategories
                .receive(on: DispatchQueue.main)
                .sink { [weak self] _ in
                    guard let allRaces = self?.allRaces else { return }
                    self?.updateRaces(allRaces)
                }
                .store(in: &bag)
        }
    }
}

// MARK: - Extensions

private extension Logger {
    static let raceListViewModel = Logger(subsystem: "feature.racing", category: "RaceListView.ViewModel")
}
