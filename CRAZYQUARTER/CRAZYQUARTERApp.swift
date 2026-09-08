//
//  CRAZYQUARTERApp.swift
//  CRAZYQUARTER
//
//  Created by Mo on 26/01/2024.
//

import SwiftUI

@main
struct CRAZYQUARTERApp: App {
    @State private var ticTacToe = TicTacToeModel(currentPlayer: false)
    
    var body: some Scene {
        WindowGroup {
            LaunchView()
                .environment(ticTacToe)
        }
    }
}

