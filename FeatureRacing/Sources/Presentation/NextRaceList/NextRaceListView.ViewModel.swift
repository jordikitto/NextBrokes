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
            /// Loading, with placeholders being displayed.
            case loading(_ placeholderCount: Int)
            /// Loaded, with races being displayed.
            case loaded(_ races: [Race])
            /// Error, with a message being displayed.
            case error(_ message: String)
            
            var isLoading: Bool {
                guard case .loading = self else { return false }
                return true
            }
        }
        
        enum Constant {
            /// Ratio for number of races to display vs number of races to load.
            ///
            /// In other words, we want to load twice as many races as we display.
            static let loadRatio = 2
        }
        
        /// Current state of the view.
        @Published private(set) var state: State
        /// Selected categories, used for filtering. Only show races that match these categories.
        @Published var selectedCategories = Set(RaceCategory.allCases)
        /// Whether user has "applied filters".
        var isFiltering: Bool {
            selectedCategories.count != RaceCategory.allCases.count
        }
        
        /// Amount of races to display to user.
        private let raceDisplayLimit: Int
        private let fetchNextRaces: FetchNextRacesUseCaseProtocol
        private let removeOldRaces: RemoveOldRacesUseCaseProtocol
        private let cleanupTrigger: DateTriggerable
        
        /// All races returned from the server.
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
        
        /// Attempt to load races from server.
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
        
        /// Updates the UI and any state using the given races.
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
        
        /// Updates the cleanup trigger to fire when the given race ended a minute ago.
        private func updateCleanupTrigger(firstRace: Race) {
            let oneMinuteAfterRaceEnds = firstRace.startDate.addingTimeInterval(60)
            cleanupTrigger.schedule(oneMinuteAfterRaceEnds)
        }
        
        /// Binds the cleanup trigger to reload all races.
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
        
        /// Binds the selected categories to update the races shown.
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
