//
//  ContentView.swift
//  CRAZYQUARTER
//
//  Created by null on 05/09/2023.
//

import SwiftUI

struct ContentView: View {
    @Environment(TicTacToeModel.self) private var ticTacToe
    @State private var viewModel = ContentViewModel()
    @AppStorage("vibro") private var vibro: Bool = true
    
    private var currentPlayerText: String {
        !ticTacToe.currentPlayer ? "X" : "O"
    }
    
    private var aiMoveText: String {
        !ticTacToe.currentPlayer ? "vous" : "l'IA"
    }
    
    private var gameOverMessage: String {
        if viewModel.mode == .ai {
            if ticTacToe.winner == .x {
                return "Vous avez gagné !"
            } else if ticTacToe.winner == .o {
                return "L'IA a gagné !"
            } else {
                return "Match nul !"
            }
        } else {
            if ticTacToe.winner == .x {
                return "X a gagné !"
            } else if ticTacToe.winner == .o {
                return "O a gagné !"
            } else {
                return "Match nul !"
            }
        }
    }
    
    var body: some View {
        @Bindable var bindableModel = ticTacToe
        
        VStack {
            HStack {
                Button("Vibration", systemImage: vibro ? "iphone.radiowaves.left.and.right" : "iphone.slash") {
                    vibro.toggle()
                }
                .labelStyle(.iconOnly)
                .frame(width: 44, height: 44)
                .clipShape(.rect(cornerRadius: 10))
                .foregroundStyle(.secondary)
                .sensoryFeedback(.impact(weight: .light), trigger: vibro)
                
                Picker("Partie", selection: $viewModel.mode) {
                    ForEach(GameMode.allCases) { mode in
                        Text(mode.rawValue).tag(mode)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal, 10)
                .onChange(of: viewModel.mode) {
                    ticTacToe.resetGame()
                }
                .sensoryFeedback(.impact(weight: .light), trigger: viewModel.mode) { _, _ in
                    vibro
                }
                
                Button("Info", systemImage: "info.circle") {
                    viewModel.popup.toggle()
                }
                .labelStyle(.iconOnly)
                .frame(width: 44, height: 44)
                .clipShape(.rect(cornerRadius: 10))
                .foregroundStyle(.secondary)
                .sensoryFeedback(.impact(weight: .heavy), trigger: viewModel.popup) { _, _ in
                    vibro
                }
                .popover(isPresented: $viewModel.popup) {
                    VStack(spacing: 12) {
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
            .padding(.horizontal)
            
            Spacer()
            
            Text(viewModel.mode == .pvp ? "Morpion - PvP" : "Morpion - IA")
                .font(.title)
                .bold()
                .foregroundStyle(.primary)
            
            Text(viewModel.mode == .pvp ? "À \(currentPlayerText) de jouer" : "À \(aiMoveText) de jouer")
                .font(.title2)
                .bold()
                .foregroundStyle(.secondary)
                .padding(.bottom)
            
            Grid {
                ForEach(0..<3) { row in
                    GridRow {
                        ForEach(0..<3) { column in
                            let index = row * 3 + column
                            SquareView(square: ticTacToe.squares[index]) {
                                ticTacToe.handlePlayerInput(at: index, mode: viewModel.mode)
                            }
                            .sensoryFeedback(.impact(weight: .medium), trigger: ticTacToe.squares[index].status) { _, newValue in
                                vibro && newValue != .empty
                            }
                        }
                    }
                }
            }
            
            Spacer()
            
            Button("Réinitialiser") {
                ticTacToe.resetGame()
            }
            .font(.title3)
            .bold()
            .padding(.horizontal, 24)
            .padding(.vertical, 10)
            .background(.thinMaterial)
            .clipShape(.rect(cornerRadius: 8))
            .foregroundStyle(.red)
            .alert("Fin de partie", isPresented: $bindableModel.gameOver) {
                Button("Rejouer") {
                    ticTacToe.resetGame()
                }
            } message: {
                Text(gameOverMessage)
            }
        }
        .sensoryFeedback(.impact(weight: .medium), trigger: ticTacToe.hapticTrigger) { _, _ in
            vibro
        }
    }
}

#Preview {
    ContentView()
        .environment(TicTacToeModel(currentPlayer: false))
        .preferredColorScheme(.dark)
}
