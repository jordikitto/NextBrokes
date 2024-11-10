//
//  CGFloat+Radius.swift
//  CoreDesign
//
//  Created by Jordi Kitto on 10/11/2024.
//

import Foundation
import SwiftUI

public extension CGFloat {
    /// Apply standard radius value.
    /// - Parameter radius: Radius style.
    static func radius(_ radius: Radius) -> CGFloat {
        radius.rawValue
    }
    
    enum Radius: CGFloat, CaseIterable {
        /// 16pt
        case large = 16
        /// 8pt
        case small = 8
    }
}

@available(iOS 16.0, *)
#Preview("Radii") {
    Grid {
        ForEach(CGFloat.Radius.allCases, id: \.rawValue) { radius in
            GridRow {
                Text(".\(String(describing: radius))")
                    .font(.caption)
                    .gridColumnAlignment(.trailing)
                RoundedRectangle(cornerRadius: .radius(radius))
                    .fill(Color.gray)
                    .frame(width: 100, height: 100)
            }
        }
    }
}
