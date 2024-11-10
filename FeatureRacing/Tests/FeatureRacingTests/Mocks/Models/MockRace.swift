//
//  MockRace.swift
//  FeatureRacing
//
//  Created by Jordi Kitto on 11/11/2024.
//

import Foundation
@testable import FeatureRacingDomain

extension Race {
    static func mock(
        id: String = UUID().uuidString,
        startDate: Date = .now,
        meetingName: String = "Meeting",
        raceNumber: Int = 1,
        category: RaceCategory = .greyhound
    ) -> Self {
        .init(
            id: id,
            startDate: startDate,
            meetingName: meetingName,
            raceNumber: raceNumber,
            category: category
        )
    }
}
