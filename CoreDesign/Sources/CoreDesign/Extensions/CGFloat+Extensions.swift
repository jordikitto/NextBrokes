//
//  CGFloat+Extensions.swift
//  CoreDesign
//
//  Created by Jordi Kitto on 10/11/2024.
//

import Foundation
import SwiftUI

public extension CGFloat {
    
    /// Apply standard spacing.
    /// - Parameter spacing: Spacing specification.
    static func spacing(_ spacing: Spacing) -> Self {
        spacing.rawValue
    }
    
    public enum Spacing: CGFloat, CaseIterable {
        case pt36 = 36
        case pt26 = 26
        case pt24 = 24
        case pt22 = 22
        case pt20 = 20
        case pt16 = 16
        case pt14 = 14
        case pt12 = 12
        case pt8 = 8
        case pt6 = 6
        case pt4 = 4
        case pt2 = 2
    }
}

@available(iOS 16.0, *)
#Preview("Spacing") {
    Grid {
        ForEach(CGFloat.Spacing.allCases, id: \.rawValue) { spacing in
            GridRow {
                Text(".pt\(spacing.rawValue.formatted())")
                    .font(.caption)
                    .gridColumnAlignment(.trailing)
                Rectangle()
                    .fill(Color.gray)
                    .frame(width: .spacing(spacing), height: 40)
                    .gridColumnAlignment(.leading)
            }
        }
    }
}
