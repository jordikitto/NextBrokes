//
//  RaceListView.Content.swift
//  FeatureRacing
//
//  Created by Jordi Kitto on 9/11/2024.
//

import SwiftUI
import FeatureRacingDomain
import CoreDesign

extension RaceListView {
    struct Content: View {
        @State private var isPresentedFilterList = false
        
        let state: ViewModel.State
        @Binding var selectedCategories: Set<RaceCategory>
        
        var body: some View {
            ScrollView {
                VStack(spacing: .zero) {
                    switch state {
                    case let .loading(count):
                        placeHolderView(count: count)
                    case let .loaded(races):
                        loadedView(races)
                    case let .error(message):
                        Text(message).foregroundStyle(.red)
                    }
                }
            }
            .overlay(alignment: .bottom) {
                Button {
                    isPresentedFilterList = true
                } label: {
                    Label("Filter", systemImage: "line.3.horizontal.decrease.circle")
                }
                .buttonStyle(.borderedProminent)
                .disabled(!state.isLoaded)
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
                                Image(systemName: "xmark")
                            }
                        }
                    }
                }
                .mediumPresentationDetent()
            }
        }
        
        private func placeHolderView(count: Int) -> some View {
            VStack {
                ForEach(0..<count, id: \.self) { index in
                    RaceListRowPlaceholderView(index: index)
                }
            }
        }
        
        private func loadedView(_ races: [Race]) -> some View {
            VStack {
                ForEach(races) { race in
                    RaceListRowView(race: race)
                        .transition(rowTransition)
                }
            }
        }
        
        private var rowTransition: AnyTransition {
            .asymmetric(
                insertion: .move(edge: .bottom).combined(with: .opacity),
                removal: .move(edge: .top).combined(with: .opacity)
            )
        }
    }
}

@available(iOS 18.0, *)
#Preview {
    @Previewable @State var state: RaceListView.ViewModel.State = .loading(5)
    @Previewable @State var selectedCategories = Set(RaceCategory.allCases)
    
    VStack {
        RaceListView.Content(
            state: state,
            selectedCategories: $selectedCategories
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
