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
    
    var body: some View {
        NavigationStack {
            VStack {
                
                Spacer()
                
                Text("CRAZYQUARTER")
                    .font(.largeTitle)
                
                Text("Une application pour jouer au morpion")
                    .font(.caption)
                
                Spacer()
                
                NavigationLink(destination: ContentView(ticTacToe: ticTacToe, viewModel: ViewModel()),
                               label: {
                    Image(systemName: "xmark.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.green)
                        .frame(width: 200, height: 200)
                })
                
                Spacer()
                Spacer()
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    LaunchView(ticTacToe: TicTacToeModel(squares: [Square](repeating: Square(status: .empty), count: 9), currentPlayer: false))
        .preferredColorScheme(.dark)
}
