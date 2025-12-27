//
//  CRAZYQUARTERApp.swift
//  CRAZYQUARTER
//
//  Created by Mo on 26/01/2024.
//

import SwiftUI

@main
struct CRAZYQUARTERApp: App {
    let viewModel = ViewModel()
    let ticTacToe: TicTacToeModel
    
    init() {
        self.ticTacToe = TicTacToeModel(squares: [Square](repeating: Square(status: .empty), count: 9), currentPlayer: false)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(ticTacToe: ticTacToe, viewModel: ViewModel())
        }
    }
}
