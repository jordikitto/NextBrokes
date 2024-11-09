//
//  RaceListRowView.swift
//  FeatureRacing
//
//  Created by Jordi Kitto on 9/11/2024.
//

import SwiftUI
import CoreDesign
import FeatureRacingDomain

struct RaceListRowView: View {
    
    let raceStartDate: Date
    let meetingName: String
    let raceNumber: Int
    let icon: Icon
    
    var body: some View {
        HStack {
            ColoredCountdownView(targetDate: raceStartDate)
            Spacer()
            HStack {
                VStack(alignment: .trailing) {
                    Text(meetingName)
                        .bold()
                    Text("Race \(raceNumber)")
                }
                IconView(icon: icon)
                    .imageScale(.large)
                    .padding(10)
                    .background {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(.systemGray5))
                    }
            }
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(.systemGray6))
        }
    }
}

extension RaceListRowView {
    init(race: Race) {
        self.init(
            raceStartDate: race.startDate,
            meetingName: race.meetingName,
            raceNumber: race.raceNumber,
            icon: race.category.icon
        )
    }
}

#Preview {
    RaceListRowView(
        raceStartDate: Date(),
        meetingName: "Flemington",
        raceNumber: 4,
        icon: .greyhound
    )
    .padding()
}
