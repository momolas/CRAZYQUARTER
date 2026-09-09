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
    
    var body: some View {
        @Bindable var ticTacToe = ticTacToe
        
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
                    AboutView()
                }
            }
            .padding(.horizontal)
            
            Spacer()
            
            Text(viewModel.mode == .pvp ? "Morpion - PvP" : "Morpion - IA")
                .font(.title)
                .bold()
                .foregroundStyle(.primary)
            
            Text(viewModel.turnMessage(currentPlayer: ticTacToe.currentPlayer))
                .font(.title2)
                .bold()
                .foregroundStyle(.secondary)
                .padding(.bottom)
            
            Grid {
                ForEach(0..<3, id: \.self) { row in
                    GridRow {
                        ForEach(0..<3, id: \.self) { column in
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
            .alert("Fin de partie", isPresented: $ticTacToe.gameOver) {
                Button("Rejouer") {
                    ticTacToe.resetGame()
                }
            } message: {
                Text(viewModel.gameOverMessage(winner: ticTacToe.winner))
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
