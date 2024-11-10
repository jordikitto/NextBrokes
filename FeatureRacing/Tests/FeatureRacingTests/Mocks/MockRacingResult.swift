//
//  MockRacingResult.swift
//  FeatureRacing
//
//  Created by Jordi Kitto on 10/11/2024.
//

import Foundation
import FeatureRacingDomain
@testable import FeatureRacingData

extension NetworkRacingRequest.RacingResult {
    static func mock(
        nextToGoIds: [String],
        raceSummaries: [String : RaceSummary]
    ) -> Self {
        .init(
            nextToGoIds: nextToGoIds,
            raceSummaries: raceSummaries
        )
    }
}
