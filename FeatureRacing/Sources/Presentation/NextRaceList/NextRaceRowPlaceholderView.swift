//
//  NextRaceRowPlaceholderView.swift
//  FeatureRacing
//
//  Created by Jordi Kitto on 9/11/2024.
//

import SwiftUI

struct NextRaceRowPlaceholderView: View {
    @State private var toggle = false
    
    let offsetIndex: Double
    
    init(index: Int) {
        self.offsetIndex = Double(index)
    }
    
    var body: some View {
        NextRaceRowView(
            raceStartDate: .now,
            meetingName: "",
            raceNumber: 0,
            icon: .greyhound
        )
        .hidden()
        .overlay {
            RoundedRectangle(cornerRadius: .radius(.large))
                .fill(color)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4 * offsetIndex) {
                withAnimation(.linear(duration: 1).repeatForever()) {
                    toggle.toggle()
                }
            }
        }
    }
    
    private var color: Color {
        toggle ? .gray.opacity(0.4) : .gray.opacity(0.2)
    }
}

#Preview {
    VStack {
        NextRaceRowPlaceholderView(index: 0)
        NextRaceRowPlaceholderView(index: 1)
        NextRaceRowPlaceholderView(index: 2)
        NextRaceRowPlaceholderView(index: 3)
        NextRaceRowPlaceholderView(index: 4)
    }
    .padding()
}
