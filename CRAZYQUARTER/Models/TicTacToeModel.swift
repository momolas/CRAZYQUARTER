//
//  TicTacToeModel.swift
//  CRAZYQUARTER
//
//  Created by Mo on 18/03/2024.
//

import Foundation
import SwiftUI
import Observation

@Observable
@MainActor
class TicTacToeModel {
    var squares: [Square]
    var currentPlayer: Bool = false          // Renamed for clarity
    var winner: SquareStatus = .empty    // Gagnant
    var gameOver: Bool = false           // Fin de partie
    
    // Haptic feedback trigger counter
    var hapticTrigger: Int = 0
    
    init(currentPlayer: Bool = false) {
        self.squares = (0..<9).map { _ in Square(status: .empty) }
        self.currentPlayer = currentPlayer
    }
    
    func resetGame() {
        for square in squares {
            square.squareStatus = .empty
        }

        currentPlayer = false
        winner = .empty
        gameOver = false
    }
    
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
        let highlight = winner == .x ? SquareStatus.xw : SquareStatus.ow
        withAnimation {
            for i in winningLine {
                squares[i].squareStatus = highlight
            }
        }
        self.winner = winner
        gameOver = true
    }
    
    func makeMove(index: Int, gameType: Bool) -> Bool {
        // If currentPlayer is false, it's X's turn. If true, it's O's turn.
        let player = currentPlayer ? SquareStatus.o : SquareStatus.x

        guard squares[index].squareStatus == .empty else { return false }
        
        squares[index].squareStatus = player
        
        if let winnerTuple = checkWinner() {
            colorize(winner: winnerTuple.0, winningLine: winnerTuple.1)
            return true
        } else if squares.allSatisfy({ $0.squareStatus != .empty }) {
            gameOver = true
            winner = .empty
            return true
        }
        
        if !currentPlayer && !gameType {
            Task {
                try? await Task.sleep(for: .seconds(0.5))
                self.makeAIMove()
                self.hapticTrigger += 1
            }
        }
        
        currentPlayer.toggle()
        
        return true
    }
    
    var boardPositions: [SquareStatus] {
        return squares.map { $0.squareStatus }
    }
    
    private func makeAIMove() {
        let board = Board(positions: boardPositions, currentTurn: .o, lastMove: -1)
        let bestMove = board.findBestMove()
        
        if bestMove >= 0 && bestMove < squares.count {
            currentPlayer = true
            _ = makeMove(index: bestMove, gameType: true)
        }
    }
}
