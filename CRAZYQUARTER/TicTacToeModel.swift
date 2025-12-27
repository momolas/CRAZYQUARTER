//
//  TicTacToeModel.swift
//  CRAZYQUARTER
//
//  Created by Mo on 18/03/2024.
//

import Foundation
import SwiftUI

@MainActor
class TicTacToeModel: ObservableObject {
    @Published var squares: [Square]
    @Published var currentPlayer: Bool = false          // Renamed for clarity
    @State private var winner: SquareStatus = .empty    // Gagnant
    @State private var gameOver: Bool = false           // Fin de partie
    
    init(squares: [Square], currentPlayer: Bool) {
        self.squares = [Square](repeating: Square(status: .empty), count: 9)
        self.currentPlayer = currentPlayer
    }
    
//    init(squares: [Square], currentPlayer: Bool, winner: SquareStatus, gameOver: Bool) {
//        self.squares = squares
//        self.currentPlayer = currentPlayer
//        self.winner = winner
//        self.gameOver = gameOver
//    }
    
    func resetGame() {
        squares = squares.map { square in
            let newSquare = square
            newSquare.squareStatus = .empty             // Ou l'état initial souhaité
            return newSquare
        }

        currentPlayer = false
    }
    
//    var gameOver: (SquareStatus, Bool) {
//        guard !gameOver else { return (.empty, false) }
//        if var winner = checkWinner() {
//            colorize(winner: winner.0, winningLine: winner.1)
////            winner = winner.0
//            return (winner.0, true)
//        } else if squares.allSatisfy({ $0.squareStatus != .empty }) {
//            gameOver = true
//            return (.empty, true)
//        }
//        return (.empty, false)
//    }
    
    private func checkWinner() -> (SquareStatus, [Int])? {
        let lines = [
            [0, 1, 2], [3, 4, 5], [6, 7, 8],
            [0, 3, 6], [1, 4, 7], [2, 5, 8],
            [0, 4, 8], [2, 4, 6]
        ]
        
        for line in lines {
            let squares = line.map { self.squares[$0] }
            if squares.allSatisfy({ $0.squareStatus == .x }) {
                return (.x, line)
            } else if squares.allSatisfy({ $0.squareStatus == .o }) {
                return (.o, line)
            }
        }
        return nil
    }
    
    func colorize(winner: SquareStatus, winningLine: [Int]) {
        withAnimation {
            for i in winningLine {
                squares[i].squareStatus = winner
            }
        }
        gameOver = true
    }
    
    func makeMove(index: Int, gameType: Bool) -> Bool {
        let player = currentPlayer ? SquareStatus.x : SquareStatus.o

        guard squares[index].squareStatus == .empty else { return false }
        
        squares[index].squareStatus = player
        
        if !currentPlayer && gameType {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.makeAIMove()
                ContentView.triggerHapticFeedback(type: 2)
                _ = self.gameOver
            }
        }
        
        currentPlayer.toggle()
        _ = self.gameOver
        
        return true
    }
    
    var boardPositions: [SquareStatus] {
        return squares.map { $0.squareStatus }
    }
    
    private func makeAIMove() {
        let board = Board(positions: boardPositions, currentTurn: .o, lastMove: -1)
        let bestMove = board.findBestMove()
        currentPlayer = true
        _ = makeMove(index: bestMove, gameType: true)
    }
}
