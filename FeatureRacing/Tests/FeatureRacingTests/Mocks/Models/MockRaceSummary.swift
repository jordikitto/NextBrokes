//
//  MockNetworkRacingRequestResponse.swift
//  FeatureRacing
//
//  Created by Jordi Kitto on 10/11/2024.
//

import Foundation
import FeatureRacingDomain
@testable import FeatureRacingData

extension NetworkRacingRequest.RacingResult.RaceSummary {
    static func mock(
        raceId: String = UUID().uuidString,
        raceNumber: Int = 1,
        meetingName: String = "Meeting",
        category: RaceCategory = .greyhound,
        advertisedStartDate: Date = .now
    ) -> Self {
        .init(
            raceId: raceId,
            raceNumber: raceNumber,
            meetingName: meetingName,
            categoryId: category.rawValue,
            advertisedStart: .init(
                seconds: Int(advertisedStartDate.timeIntervalSince1970)
            )
        )
    }
}
