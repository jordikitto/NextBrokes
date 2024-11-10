//
//  NetworkRacingRequest.swift
//  FeatureRacing
//
//  Created by Jordi Kitto on 9/11/2024.
//

import Foundation
import CoreNetworking

public struct NetworkRacingRequest: NetworkRequestProtocol {
    public typealias Response = NetworkDataResponse<RacingResult>
    
    public let path: String
    public let headers: [String : String?]
    
    public init(method: Method, count: Int) {
        self.path = "/racing/"
        self.headers = [
            "method": method.rawValue,
            "count": "\(count)"
        ]
    }
    
    public enum Method: String {
        case nextRaces = "nextraces"
    }
    
    public struct RacingResult: Decodable {
        public let nextToGoIds: [String]
        public let raceSummaries: [String: RaceSummary]
        
        public struct RaceSummary: Decodable {
            public let raceId: String
            public let raceNumber: Int
            public let meetingName: String
            public let categoryId: String
            public let advertisedStart: AdvertisedStart
            
            public struct AdvertisedStart: Decodable {
                public let seconds: Int
            }
        }
    }
}
