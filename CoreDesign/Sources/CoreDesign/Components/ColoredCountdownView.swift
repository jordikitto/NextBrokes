//
//  ColoredCountdownView.swift
//  CoreDesign
//
//  Created by Jordi Kitto on 9/11/2024.
//

import SwiftUI

public struct ColoredCountdownView: View {
    @ScaledMetric private var minWidth: CGFloat = 80
    
    @State private var secondsRemaining: Int
    
    let targetDate: Date
    let timer = Timer.publish(
        every: 1,
        on: .main,
        in: .common
    ).autoconnect()
    
    public init(targetDate: Date) {
        self.targetDate = targetDate
        self._secondsRemaining = State(
            initialValue: Int(targetDate.timeIntervalSinceNow)
        )
    }
    
    public var body: some View {
        Group {
            prefixText
            +
            Text(targetDate, style: .timer)
        }
        .padding(.spacing(.pt12))
        .frame(minWidth: minWidth)
        .background {
            RoundedRectangle(cornerRadius: .radius(.small))
                .fill(backgroundColor)
                .animation(.linear, value: secondsRemaining)
        }
        .onReceive(timer) { _ in
            secondsRemaining = Int(targetDate.timeIntervalSinceNow)
        }
    }
    
    private var prefixText: Text {
        guard secondsRemaining < 0 else { return Text("") }
        return Text("-")
    }
    
    private var backgroundColor: Color {
        if secondsRemaining < 0 {
            Color.red
        } else if secondsRemaining < 20 {
            Color.orange
        } else if secondsRemaining < 60 {
            Color.green
        }  else {
            Color.gray.opacity(0.3)
        }
    }
}

#Preview {
    ColoredCountdownView(targetDate: .now.addingTimeInterval(2))
    ColoredCountdownView(targetDate: .now.addingTimeInterval(22))
    ColoredCountdownView(targetDate: .now.addingTimeInterval(62))
    ColoredCountdownView(targetDate: .now.addingTimeInterval(60 * 2))
    ColoredCountdownView(targetDate: .now.addingTimeInterval(60 * 11))
}
