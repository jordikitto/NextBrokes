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
            VStack(spacing: .zero) {
                switch state {
                case .loading:
                    VStack {
                        ForEach(0..<5) { index in
                            RaceListRowPlaceholderView(index: index)
                        }
                    }
                case let .loaded(races):
                    VStack {
                        ForEach(races) { race in
                            RaceListRowView(race: race)
                        }
                    }
                case let .error(message):
                    Text(message).foregroundStyle(.red)
                }
            }
            .animation(.easeInOut, value: state)
        }
    }
}

@available(iOS 18.0, *)
#Preview {
    @Previewable @State var state: RaceListView.ViewModel.State = .loading
    
    ZStack {
        RaceListView.Content(state: state)
        VStack {
            Spacer()
            HStack {
                Button("Loading") {
                    state = .loading
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
