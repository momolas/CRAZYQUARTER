//
//  ContentView.swift
//  TicTacToe
//
//  Created by null on 05/09/2023.
//

import SwiftUI
import Combine
import Foundation

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme
    var ticTacToe: TicTacToeModel
    @State var viewModel: ContentViewModel
    
    @AppStorage("vibro") private var vibro: Bool = true
    
    var currentPlayerText: String {
        return ticTacToe.currentPlayer == false ? "X" : "O"
    }
    
    var aiMoveText: String {
        return ticTacToe.currentPlayer == false ? "vous" : "l'IA"
    }
    
    func resetGame() {
        ticTacToe.resetGame()
    }
    
    func buttonAction(_ index : Int) {
        if (ticTacToe.currentPlayer == false && viewModel.selection == false) || viewModel.selection == true {
            _ = ticTacToe.makeMove(index: index, gameType: viewModel.selection)
        }
    }
    
    var body: some View {
        @Bindable var bindableModel = ticTacToe
        
        VStack {
            HStack {
                Button(action: {
                    vibro.toggle()
                }, label: {
                    let icon = vibro ? "iphone.radiowaves.left.and.right" : "iphone.slash"
                    let padd: CGFloat = vibro ? 25 : 31
                    Image(systemName: icon)
                        .padding(.horizontal, padd)
                        .clipShape(.rect(cornerRadius: 10))
                        .foregroundStyle(colorScheme == .dark ? Color.white.opacity(0.7) : Color.black.opacity(0.7))
                })
				.sensoryFeedback(.impact(weight: .light), trigger: vibro)
                
                Picker(selection: $viewModel.selection, label: Text("Partie")) {
                    Text("IA")
                        .tag(false)
                    Text("PvP")
                        .tag(true)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal, 10)
                .onChange(of: viewModel.selection) { oldValue, newValue in
                    resetGame()
                }
				.sensoryFeedback(.impact(weight: .light), trigger: viewModel.selection)
                
                ZStack {
                    Button(action: {
                        viewModel.popup.toggle()
                    }, label: {
                        Image(systemName: "info.circle")
                            .padding(.horizontal, 30)
                            .clipShape(.rect(cornerRadius: 10))
                            .foregroundStyle(colorScheme == .dark ? Color.white.opacity(0.7) : Color.black.opacity(0.7))
                    })
					.sensoryFeedback(.impact(weight: .heavy), trigger: viewModel.popup)
                }
                .popover(isPresented: $viewModel.popup) {
                    ZStack {
                        VStack {
                            Text("TicTacToe")
                                .bold()
                                .font(.system(size: 80))
                                .padding(.top, 20)
                                .foregroundStyle(colorScheme == .dark ? Color.white.opacity(0.7) : Color.black.opacity(0.7))
                            
                            Text("Demo Swift App, made by Momo L'As")
                                .bold()
                                .font(.title3)
                                .foregroundStyle(colorScheme == .dark ? Color.white.opacity(0.7) : Color.black.opacity(0.7))
                        }
                        .padding(.top, 3)
                    }
                }
            }
            
            Spacer()
            
            Text(viewModel.selection == false ? "Morpion - IA" : "Morpion - PvP")
                .bold()
                .font(.title)
                .foregroundStyle(colorScheme == .dark ? Color.white.opacity(0.7) : Color.black.opacity(0.7))
            
            Text(viewModel.selection == true ? "À \(currentPlayerText) de jouer" : "À \(aiMoveText) de jouer")
                .bold()
                .font(.title2)
                .padding(.bottom)
                .foregroundStyle(colorScheme == .dark ? Color.white.opacity(0.7) : Color.black.opacity(0.7))
            
            Grid {
                ForEach(0..<3) { row in
                    GridRow {
                        ForEach(0..<3) { column in
                            let index = row * 3 + column
                            SquareView(square: ticTacToe.squares[index], action: {
                                self.buttonAction(index)
                            })
                            .sensoryFeedback(.impact(weight: .medium), trigger: ticTacToe.squares[index].squareStatus) { oldValue, newValue in
                                return newValue != .empty
                            }
                        }
                    }
                }
            }
            
            Spacer()
            
            Button(action: {
                resetGame()
            }, label: {
                Text("Réinitialiser")
                    .foregroundStyle(Color.red.opacity(0.7))
            })
            .font(.title3)
            .bold()
            .padding(.horizontal, 24)
            .padding(.vertical, 10)
            .background(.thinMaterial)
            .clipShape(.rect(cornerRadius: 5))
            .alert(isPresented: $bindableModel.gameOver) {
                var text = ""
                
                if viewModel.selection == false {
                    if ticTacToe.winner == .x {
                        text = "Vous avez gagné !"
                    } else if ticTacToe.winner == .o {
                        text = "L'IA a gagné !"
                    } else {
                        text = "Match nul !"
                    }
                } else {
                    if ticTacToe.winner == .x {
                        text = "X a gagné !"
                    } else if ticTacToe.winner == .o {
                        text = "O a gagné !"
                    } else {
                        text = "Match nul !"
                    }
                }
                
                return Alert(
                    title: Text(text),
                    dismissButton: .cancel(Text("Ok"), action: {
                        resetGame()
                    })
                )
            }
        }
        .sensoryFeedback(.impact(weight: .medium), trigger: ticTacToe.hapticTrigger)
    }
}

#Preview {
    ContentView(ticTacToe: TicTacToeModel(currentPlayer: false), viewModel: ContentViewModel())
        .preferredColorScheme(.dark)
}
