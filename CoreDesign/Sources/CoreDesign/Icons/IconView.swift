//
//  IconView.swift
//  CoreDesign
//
//  Created by Jordi Kitto on 9/11/2024.
//

import SwiftUI

public struct IconView: View {
    @Environment(\.imageScale) var imageScale
    
    let icon: Icon
    
    public init(icon: Icon) {
        self.icon = icon
    }
    
    public var body: some View {
        Image(icon.imageResource)
            .resizable()
            .frame(
                width: size.width,
                height: size.height
            )
    }
    
    private var size: CGSize {
        switch imageScale {
        case .large: return .init(width: 32, height: 32)
        case .medium: return .init(width: 22, height: 22) // Default
        case .small: return .init(width: 16, height: 16)
        default: return .init(width: 22, height: 22)
        }
    }
}

#Preview {
    VStack {
        ForEach(Icon.allCases, id: \.self) { icon in
            IconView(icon: icon)
        }
        .imageScale(.large)
    }
}
