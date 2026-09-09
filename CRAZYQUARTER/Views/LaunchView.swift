//
//  LaunchView.swift
//  CRAZYQUARTER
//
//  Created by Mo on 26/01/2024.
//

import SwiftUI

struct LaunchView: View {
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                Text("CRAZYQUARTER")
                    .font(.largeTitle)
                    .bold()
                
                Text("Une application pour jouer au morpion")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                Spacer()
                
                NavigationLink(value: Route.game) {
                    VStack {
                        Image(systemName: "xmark.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundStyle(.green)
                            .frame(width: 180, height: 180)
                        
                        Text("Lancer la partie")
                            .font(.headline)
                            .foregroundStyle(.primary)
                    }
                }
                .accessibilityLabel("Lancer une partie de morpion")
                
                Spacer()
            }
            .navigationTitle("CRAZYQUARTER")
            .toolbarTitleDisplayMode(.inline)
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .game:
                    ContentView()
                }
            }
        }
    }
}

#Preview {
    LaunchView()
        .environment(TicTacToeModel())
        .preferredColorScheme(.dark)
}
