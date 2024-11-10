//
//  HeaderView.swift
//  CoreDesign
//
//  Created by Jordi Kitto on 10/11/2024.
//

import SwiftUI

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
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(.systemGray2))
                    .ignoresSafeArea(.container, edges: .top)
            }
    }
}

#Preview {
    HeaderView(title: "Next to go racing")
}
