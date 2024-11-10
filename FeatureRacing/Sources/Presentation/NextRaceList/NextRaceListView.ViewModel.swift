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
            static let loadLimit = 10
            static let displayLimit = 5
        }
        
        @Published private(set) var state: State = .loading(Constant.displayLimit)
        @Published var selectedCategories = Set(RaceCategory.allCases)
        
        var isFiltering: Bool {
            selectedCategories.count != RaceCategory.allCases.count
        }
        
        private let fetchNextRaces: FetchNextRacesUseCaseProtocol
        private let removeOldRaces: RemoveOldRacesUseCaseProtocol
        private let cleanupTrigger: DateTriggerable
        
        private var allRaces: [Race]?
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
            bindFiltering()
        }
        
        func load() async {
            do {
                let races = try await fetchNextRaces(count: Constant.loadLimit)
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
            let displayRaces = Array(filteredRaces.prefix(Constant.displayLimit))
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
