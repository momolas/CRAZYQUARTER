//
//  ContentView.swift
//  CRAZYQUARTER
//
//  Created by Mo on 26/01/2024.
//

import SwiftUI

struct LaunchView: View {
    
    let ticTacToe: TicTacToeModel
    
    var body: some View {
        NavigationStack {
            VStack {
                
                Spacer()
                
                Text("CRAZYQUARTER")
                    .font(.largeTitle)
                
                Text("Une application pour jouer au morpion")
                    .font(.caption)
                
                Spacer()
                
                NavigationLink(value: "Game") {
                    Image(systemName: "xmark.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundStyle(.green)
                        .frame(width: 200, height: 200)
                }
                
                Spacer()
                Spacer()
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: String.self) { value in
                if value == "Game" {
                    ContentView(ticTacToe: ticTacToe, viewModel: ContentViewModel())
                }
            }
        }
    }
}

#Preview {
    LaunchView(ticTacToe: TicTacToeModel())
        .preferredColorScheme(.dark)
}
