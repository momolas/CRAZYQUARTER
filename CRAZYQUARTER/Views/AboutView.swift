//
//  AboutView.swift
//  CRAZYQUARTER
//
//  Created by Mo on 08/09/2026.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        VStack {
            Text("TicTacToe")
                .font(.largeTitle)
                .bold()
                .foregroundStyle(.primary)
            
            Text("Demo Swift App, made by Momo L'As")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding()
    }
}

#Preview {
    AboutView()
        .preferredColorScheme(.dark)
}
