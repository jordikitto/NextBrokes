//
//  HeaderView.swift
//  CoreDesign
//
//  Created by Jordi Kitto on 10/11/2024.
//

import SwiftUI

/// A view that displays a header with a title.
///
/// Should be used as the topmost view in a screen, to act as the header for the content.
public struct HeaderView: View {
    
    let title: String
    
    public init(title: String) {
        self.title = title
    }
    
    public var body: some View {
        Text(title.uppercased())
            .font(.title3)
            .fontWeight(.bold)
            .foregroundStyle(.white)
            .padding(.spacing(.pt16))
            .frame(maxWidth: .infinity, alignment: .leading)
            .background {
                RoundedRectangle(cornerRadius: .radius(.large))
                    .fill(Color.accentColor)
                    .ignoresSafeArea(.container, edges: .top)
            }
    }
}

#Preview {
    HeaderView(title: "Next to go racing")
}
