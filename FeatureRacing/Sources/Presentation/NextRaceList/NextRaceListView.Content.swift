//
//  NextRaceListView.Content.swift
//  FeatureRacing
//
//  Created by Jordi Kitto on 9/11/2024.
//

import SwiftUI
import FeatureRacingDomain
import CoreDesign
import SFSafeSymbols

extension NextRaceListView {
    struct Content: View {
        @State private var isPresentedFilterList = false
        
        let state: ViewModel.State
        @Binding var selectedCategories: Set<RaceCategory>
        let isFiltering: Bool
        
        var body: some View {
            VStack(spacing: .zero) {
                switch state {
                case let .loading(count):
                    placeHolderView(count: count)
                case let .loaded(races):
                    loadedView(races)
                case let .error(message):
                    errorView(message)
                }
            }
            .frame(maxHeight: .infinity) // Ensures error view also fills screen
            .overlay(alignment: .bottom) {
                Button {
                    isPresentedFilterList = true
                } label: {
                    Label("Filter", systemSymbol: filterSymbol)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .disabled(state.isLoading)
                .padding(.bottom, .spacing(.pt20))
            }
            .animation(.easeInOut, value: state)
            .sheet(isPresented: $isPresentedFilterList) {
                NavigationView {
                    RaceCategoryFilterListView(
                        selectedCategories: $selectedCategories
                    )
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button {
                                isPresentedFilterList = false
                            } label: {
                                Image(systemSymbol: .xmark)
                            }
                        }
                    }
                }
                .mediumPresentationDetent()
            }
        }
        
        private func scrollView<V: View>(
            @ViewBuilder _ content: () -> V
        ) -> some View {
            ScrollView {
                VStack(spacing: .spacing(.pt2)) {
                    content()
                        .padding(.top, .spacing(.pt16))
                }
            }
        }
        
        private func placeHolderView(count: Int) -> some View {
            scrollView {
                ForEach(0..<count, id: \.self) { index in
                    NextRaceRowPlaceholderView(index: index)
                }
            }
        }
        
        private func loadedView(_ races: [Race]) -> some View {
            scrollView {
                ForEach(races) { race in
                    NextRaceRowView(race: race)
                        .transition(
                            rowTransition(
                                isFirst: race == races.first,
                                isLast: race == races.last
                            )
                        )
                }
            }
        }
        
        private func errorView(_ message: String) -> some View {
            VStack(spacing: 8) {
                Image(systemSymbol: .exclamationmarkCircle)
                    .imageScale(.large)
                    .padding(.top, .spacing(.pt36))
                Text(message)
                Spacer()
            }
            .font(.title2)
            .multilineTextAlignment(.center)
            .foregroundStyle(.secondary)
            .padding(.horizontal, .spacing(.pt20))
            .transition(.scale(scale: 0.8).combined(with: .opacity))
        }
        
        private func rowTransition(isFirst: Bool, isLast: Bool) -> AnyTransition {
            if isFirst {
                return .move(edge: .top).combined(with: .opacity)
            } else if isLast {
                return .move(edge: .bottom).combined(with: .opacity)
            } else {
                return .scale(scale: 0.8).combined(with: .opacity)
            }
        }
        
        private var filterSymbol: SFSymbol {
            isFiltering
            ? .line3HorizontalDecreaseCircleFill
            : .line3HorizontalDecreaseCircle
        }
    }
}

@available(iOS 18.0, *)
#Preview {
    @Previewable @State var state: NextRaceListView.ViewModel.State = .loading(5)
    @Previewable @State var selectedCategories = Set(RaceCategory.allCases)
    
    VStack {
        NextRaceListView.Content(
            state: state,
            selectedCategories: $selectedCategories,
            isFiltering: selectedCategories.count != RaceCategory.allCases.count
        )
        VStack {
            HStack {
                Button("Loading") {
                    state = .loading(5)
                }
                Button("Loaded") {
                    let races = (0..<5).map { index in
                        Race(
                            id: "\(index)",
                            startDate: Date().addingTimeInterval(TimeInterval(10 * index)),
                            meetingName: "Meeting \(index)",
                            raceNumber: index,
                            category: RaceCategory.allCases.randomElement() ?? .horse
                        )
                    }
                    state = .loaded(races)
                }
                Button("Error") {
                    state = .error("An error occurred")
                }
            }
            .buttonStyle(.bordered)
        }
    }
    .padding()
}
