//
//  NextRaceRowView.swift
//  FeatureRacing
//
//  Created by Jordi Kitto on 9/11/2024.
//

import SwiftUI
import CoreDesign
import FeatureRacingDomain

struct NextRaceRowView: View {
    
    let raceStartDate: Date
    let meetingName: String
    let raceNumber: Int
    let category: RaceCategory
    
    var body: some View {
        HStack(spacing: .zero) {
            ColoredCountdownView(targetDate: raceStartDate)
            Spacer()
            HStack(spacing: .spacing(.pt8)) {
                VStack(alignment: .trailing) {
                    Text(meetingName)
                        .bold()
                        .accessibilityLabel("Meeting \(meetingName).")
                    Text("Race \(raceNumber)")
                }
                IconView(icon: category.icon)
                    .imageScale(.large)
                    .padding(.spacing(.pt8))
                    .background {
                        RoundedRectangle(cornerRadius: .radius(.small))
                            .fill(Color(.systemGray5))
                    }
                    .accessibilityLabel("Category \(category.title)")
            }
            .accessibilityElement(children: .combine)
        }
        .padding(.spacing(.pt14))
        .multilineTextAlignment(.trailing)
        .background {
            RoundedRectangle(cornerRadius: .radius(.large))
                .fill(Color(.systemGray6))
        }
    }
}

extension NextRaceRowView {
    init(race: Race) {
        self.init(
            raceStartDate: race.startDate,
            meetingName: race.meetingName,
            raceNumber: race.raceNumber,
            category: race.category
        )
    }
}

#Preview {
    VStack {
        NextRaceRowView(
            raceStartDate: Date(),
            meetingName: "Flemington",
            raceNumber: 4,
            category: .greyhound
        )
        NextRaceRowView(
            raceStartDate: Date().addingTimeInterval(20),
            meetingName: "Wentworth",
            raceNumber: 100,
            category: .harness
        )
        .environment(\.dynamicTypeSize, .xxxLarge)
    }
    .padding()
}
