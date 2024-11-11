//
//  PresentationDetents.swift
//  CoreDesign
//
//  Created by Jordi Kitto on 10/11/2024.
//

import Foundation
import SwiftUICore

public extension View {
    @ViewBuilder
    /// Backwards compatible method for `.presentationDetents([.medium])`.
    func mediumPresentationDetent() -> some View {
        if #available(iOS 16.0, *) {
            self.presentationDetents([.medium])
        } else {
            self
        }
    }
}
