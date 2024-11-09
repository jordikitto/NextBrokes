//
//  Race.swift
//  FeatureRacing
//
//  Created by Jordi Kitto on 9/11/2024.
//

import Foundation

public struct Race: Identifiable, Equatable {
    public var id: String
    public let startDate: Date
    public let meetingName: String
    public let raceNumber: Int
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
