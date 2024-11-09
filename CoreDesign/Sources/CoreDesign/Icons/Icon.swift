//
//  Icon.swift
//  CoreDesign
//
//  Created by Jordi Kitto on 9/11/2024.
//

import Foundation

public enum Icon: CaseIterable {
    case greyhound
    case harness
    case horse
    
    var imageResource: ImageResource {
        switch self {
        case .greyhound: .greyhound
        case .harness: .harness
        case .horse: .horseRacing
        }
    }
}
