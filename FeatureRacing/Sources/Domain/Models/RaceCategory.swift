//
//  RaceCategory.swift
//  FeatureRacing
//
//  Created by Jordi Kitto on 9/11/2024.
//

import Foundation
import CoreDesign

/// Category of a ``Race``.
///
/// Values are used to identify categories from network responses.
public enum RaceCategory: String, Identifiable, CaseIterable, Equatable, Sendable {
    case greyhound = "9daef0d7-bf3c-4f50-921d-8e818c60fe61"
    case harness = "161d9be2-e909-4326-8c2c-35ed71fb460b"
    case horse = "4a2788f8-e825-4d36-9894-efd4baf1cfae"
    
    public var id: String { rawValue }
    
    /// User presentable title for the category.
    public var title: String {
        switch self {
        case .greyhound: "Greyhound"
        case .harness: "Harness"
        case .horse: "Horse"
        }
    }
    
    /// Icon to represent the category.
    public var icon: Icon {
        switch self {
        case .greyhound: .greyhound
        case .harness: .harness
        case .horse: .horse
        }
    }
}
