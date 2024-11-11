//
//  Race.swift
//  FeatureRacing
//
//  Created by Jordi Kitto on 9/11/2024.
//

import Foundation
import FeatureRacingData
import CoreNetworking

/// A racing event.
public struct Race: Identifiable, Equatable, Sendable {
    /// Unique identifier for the race.
    public var id: String
    /// Date which the race starts.
    public let startDate: Date
    /// Name of where the race takes place.
    public let meetingName: String
    /// Number of the race.
    public let raceNumber: Int
    /// Category of the race.
    public let category: RaceCategory
    
    public init(
        id: String,
        startDate: Date,
        meetingName: String,
        raceNumber: Int,
        category: RaceCategory
    ) {
        self.id = id
        self.startDate = startDate
        self.meetingName = meetingName
        self.raceNumber = raceNumber
        self.category = category
    }
}

extension Race {
    /// Initialise from a network response.
    init(from summary: NetworkRacingRequest.RacingResult.RaceSummary) throws {
        guard let category = RaceCategory(rawValue: summary.categoryId) else {
            throw NetworkError.decoding("category", summary.categoryId)
        }
        
        self.init(
            id: summary.raceId,
            startDate: .init(timeIntervalSince1970: TimeInterval(summary.advertisedStart.seconds)),
            meetingName: summary.meetingName,
            raceNumber: summary.raceNumber,
            category: category
        )
    }
}
