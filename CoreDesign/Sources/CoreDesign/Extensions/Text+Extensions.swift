//
//  Text+Extensions.swift
//  CoreDesign
//
//  Created by Jordi Kitto on 9/11/2024.
//

import Foundation
import SwiftUI

extension Text {
    init?(optional content: (any StringProtocol)?) {
        guard let content else { return nil }
        self.init(content)
    }
}
