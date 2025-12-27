//
//  ContentView.swift
//  CRAZYQUARTER
//
//  Created by Mo on 26/01/2024.
//

import SwiftUI

struct LaunchView: View {
    
    // 1. Dependency Injection
    let ticTacToe: TicTacToeModel
    // We should probably create the viewModel here or in the App, or inside NavigationLink destination.
    // Creating it inside Destination is fine if it doesn't need to persist across this view.
    
    var body: some View {
        NavigationStack {
            VStack {
                
                Spacer()
                
                Text("CRAZYQUARTER")
                    .font(.largeTitle)
                
                Text("Une application pour jouer au morpion")
                    .font(.caption)
                
                Spacer()
                
                // Using NavigationLink with value-based navigation is preferred, but Destination is okay for simple cases if simpler.
                // Directives say: "Use the navigationDestination(for:) modifier to specify navigation"
                
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
