//
//  RaceListView.Content.swift
//  FeatureRacing
//
//  Created by Jordi Kitto on 9/11/2024.
//

import SwiftUI
import FeatureRacingDomain

extension RaceListView {
    struct Content: View {
        
        let state: ViewModel.State
        
        var body: some View {
            ScrollView {
                VStack(spacing: .zero) {
                    switch state {
                    case let .loading(count):
                        VStack {
                            ForEach(0..<count, id: \.self) { index in
                                RaceListRowPlaceholderView(index: index)
                            }
                        }
                    case let .loaded(races):
                        VStack {
                            ForEach(races) { race in
                                RaceListRowView(race: race)
                                    .transition(rowTransition)
                            }
                        }
                    case let .error(message):
                        Text(message).foregroundStyle(.red)
                    }
                }
                .animation(.easeInOut, value: state)
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
    
    ZStack {
        RaceListView.Content(state: state)
        VStack {
            Spacer()
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
