//
//  ContentView.swift
//  TicTacToe
//
//  Created by null on 05/09/2023.
//

import SwiftUI
//import UIKit
import Combine
import Foundation

class ViewModel: ObservableObject {
    @Published var gameOver: Bool = false
    @Published var winner: SquareStatus = .empty
}

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var ticTacToe: TicTacToeModel
    @ObservedObject var viewModel: ViewModel
    
    @State private var selection: Bool = false          // Mode de jeu (false: IA, true: PvP)
    @State private var move: Bool = false               // Inutilisée, peut être supprimée
    @State private var vibro: Bool = true               // Vibration activée par défaut
    @State private var popup: Bool = false              // Visibilité de l'info-bulle
    
    static func setVibro(mode: Bool) {
        UserDefaults.standard.set(mode, forKey: "vibro")
    }
    
    static func triggerHapticFeedback(type: Int, overdie: Bool = false) {
        let vibro = Foundation.UserDefaults.standard.value(forKey: "vibro") as? Bool
        
        if vibro == true || overdie == true {
            if type == 1 {
                let generator = UIImpactFeedbackGenerator(style: .soft)
                generator.impactOccurred()
            } else if type == 2 {
                let generator = UIImpactFeedbackGenerator(style: .medium)
                generator.impactOccurred()
            } else if type == 3 {
                let generator = UIImpactFeedbackGenerator(style: .rigid)
                generator.impactOccurred()
            } else if type == 4 {
                let generator = UIImpactFeedbackGenerator(style: .rigid)
                generator.impactOccurred()
            }
        }
    }
    
    func buttonAction(_ index : Int) {
        if (ticTacToe.currentPlayer == false && selection == false) || selection == true {
            _ = ticTacToe.makeMove(index: index, gameType: selection)
        }
        ContentView.triggerHapticFeedback(type: 2)
    }
    
    var currentPlayer: String {
        return ticTacToe.currentPlayer == false ? "X" : "O"
    }
    
    var AIMove: String {
        return ticTacToe.currentPlayer == false ? "vous" : "l'IA"
    }
    
    func resetGame() {
        // Réinitialiser le modèle
        ticTacToe.resetGame()
        // Réinitialiser les variables
        withAnimation {
            self.selection = false
            self.move = false
            viewModel.winner = .empty
            viewModel.gameOver = false
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    ContentView.triggerHapticFeedback(type: 1, overdie: true)
                    vibro.toggle()
                    ContentView.setVibro(mode: vibro)
                }, label: {
                    let icon = vibro == true ? "iphone.radiowaves.left.and.right" : "iphone.slash"
                    let padd: CGFloat = vibro == true ? 25 : 31
                    Image(systemName: icon)
                        .padding(.horizontal, padd)
                        .cornerRadius(10)
                        .foregroundColor(colorScheme == .dark ? Color.white.opacity(0.7) : Color.black.opacity(0.7))
                })
                
                Picker(selection: $selection, label: Text("Partie")) {
                    Text("IA")
                        .tag(false)
                    Text("PvP")
                        .tag(true)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal, 10)
                .onChange(of: selection) {
                    resetGame()
                    ContentView.triggerHapticFeedback(type: 1)
                }
                
                ZStack {
                    Button(action: {
                        ContentView.triggerHapticFeedback(type: 4)
                        popup.toggle()
                    }, label: {
                        Image(systemName: "info.circle")
                            .padding(.horizontal, 30)
                            .cornerRadius(10)
                            .foregroundColor(colorScheme == .dark ? Color.white.opacity(0.7) : Color.black.opacity(0.7))
                    })
                }
                .popover(isPresented: $popup) {
                    ZStack { // 4
                        VStack {
                            Text("TicTacToe")
                                .bold()
                                .font(.system(size: 80))
                                .padding(.top, 20)
                                .foregroundColor(colorScheme == .dark ? Color.white.opacity(0.7) : Color.black.opacity(0.7))
                            
                            Text("Demo Swift App, made by Momo L'As")
                                .bold()
                                .font(.title3)
                                .foregroundColor(colorScheme == .dark ? Color.white.opacity(0.7) : Color.black.opacity(0.7))
                        }
                        .padding(.top, 3)
                    }
                }
            }
            
            Spacer()
            
            Text(self.selection == false ? "Morpion - IA" : "Morpion - PvP")
                .bold()
                .font(.title)
                .foregroundColor(colorScheme == .dark ? Color.white.opacity(0.7) : Color.black.opacity(0.7))
            
            Text(self.selection == true ? "À \(currentPlayer) de jouer" : "À \(AIMove) de jouer")
                .bold()
                .font(.title2)
                .padding(.bottom)
                .foregroundColor(colorScheme == .dark ? Color.white.opacity(0.7) : Color.black.opacity(0.7))
            
            ForEach(0 ..< ticTacToe.squares.count / 3, id: \.self, content: { row in
                HStack {
                    ForEach(0 ..< 3, content: { column in
                        let index = row * 3 + column
                        SquareView(square: ticTacToe.squares[index], action: { self.buttonAction(index) })
                    })
                }
            })
            
            Spacer()
            
            Button(action: {
                resetGame()
                ContentView.triggerHapticFeedback(type: 3)
            }, label: {
                Text("Réinitialiser")
                    .foregroundColor(Color.red.opacity(0.7))
            })
            .font(.title3)
            .fontWeight(.semibold)
            .padding(.horizontal, 24)
            .padding(.vertical, 10)
            .background(.thinMaterial)
            .cornerRadius(5)
            .alert(isPresented: $viewModel.gameOver, content: {
                var text = ""
                
                if self.selection == false {
                    if viewModel.winner == .x {
                        text = "Vous avez gagné !"
                    } else if viewModel.winner == .o {
                        text = "L'IA a gagné !"
                    } else {
                        text = "Match nul !"
                    }
                } else {
                    if viewModel.winner == .x {
                        text = "X a gagné !"
                    } else if viewModel.winner == .o {
                        text = "O a gagné !"
                    } else {
                        text = "Match nul !"
                    }
                }
                
                return Alert(title: Text(text), dismissButton: Alert.Button.cancel(Text("Ok"), action: {
                    resetGame()
                })
                )
            })
        }
    }
}

#Preview {
    ContentView(ticTacToe: TicTacToeModel(squares: [Square](repeating: Square(status: .empty), count: 9), currentPlayer: false), viewModel: ViewModel())
        .preferredColorScheme(.dark)
}
