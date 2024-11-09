//
//  NextBrokesApp.swift
//  NextBrokes
//
//  Created by Jordi Kitto on 9/11/2024.
//

import SwiftUI

@main
struct NextBrokesApp: App {
    private let dependencyContainer: DependencyContainer
    
    init() {
        self.dependencyContainer = .shared
    }
    
    var body: some Scene {
        WindowGroup {
            NextRacesView()
        }
    }
}
