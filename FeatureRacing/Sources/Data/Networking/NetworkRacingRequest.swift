//
//  NetworkRacingRequest.swift
//  FeatureRacing
//
//  Created by Jordi Kitto on 9/11/2024.
//

import Foundation
import CoreNetworking

/// Request to fetch racing data.
public struct NetworkRacingRequest: NetworkRequestProtocol {
    public typealias Response = NetworkDataResponse<RacingResult>
    
    public let path: String
    public let parameters: [String : String?]
    
    /// Create a new request to fetch racing data.
    /// - Parameters:
    ///   - method: Method to fetch races with.
    ///   - count: Amount of races to fetch.
    public init(method: Method, count: Int) {
        self.path = "/racing/"
        self.parameters = [
            "method": method.rawValue,
            "count": "\(count)"
        ]
    }
    
    public enum Method: String {
        case nextRaces = "nextraces"
    }
    
    public struct RacingResult: Decodable, Sendable {
        public let nextToGoIds: [String]
        public let raceSummaries: [String: RaceSummary]
        
        public struct RaceSummary: Decodable, Sendable {
            public let raceId: String
            public let raceNumber: Int
            public let meetingName: String
            public let categoryId: String
            public let advertisedStart: AdvertisedStart
            
            public struct AdvertisedStart: Decodable, Sendable {
                public let seconds: Int
            }
        }
    }
}
