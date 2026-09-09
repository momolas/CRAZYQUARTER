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
final class TicTacToeModel {
    var squares: [Square]
    var currentPlayer: Bool = false          // Renamed for clarity
    var winner: SquareStatus = .empty    // Gagnant
    var gameOver: Bool = false           // Fin de partie
    
    // Haptic feedback trigger counter
    var hapticTrigger: Int = 0
    
    private var aiTask: Task<Void, Never>?
    
    init(currentPlayer: Bool = false) {
        self.squares = (0..<9).map { Square(id: $0, status: .empty) }
        self.currentPlayer = currentPlayer
    }
    
    func resetGame() {
        aiTask?.cancel()
        aiTask = nil
        
        for i in squares.indices {
            squares[i].status = .empty
        }

        currentPlayer = false
        winner = .empty
        gameOver = false
    }
    
    private func checkWinner() -> (SquareStatus, [Int])? {
        for line in Board.winningLines {
            let squares = line.map { self.squares[$0] }
            if squares.allSatisfy({ $0.status == .x }) {
                return (.x, line)
            } else if squares.allSatisfy({ $0.status == .o }) {
                return (.o, line)
            }
        }
        return nil
    }
    
    func colorize(winner: SquareStatus, winningLine: [Int]) {
        let highlight = winner == .x ? SquareStatus.xw : SquareStatus.ow
        withAnimation {
            for i in winningLine {
                squares[i].status = highlight
            }
        }
        self.winner = winner
        gameOver = true
        aiTask?.cancel()
        aiTask = nil
    }
    
    func makeMove(index: Int, gameType: Bool) -> Bool {
        // If currentPlayer is false, it's X's turn. If true, it's O's turn.
        let player = currentPlayer ? SquareStatus.o : SquareStatus.x

        guard squares[index].status == .empty else { return false }
        
        squares[index].status = player
        
        if let winnerTuple = checkWinner() {
            colorize(winner: winnerTuple.0, winningLine: winnerTuple.1)
            return true
        } else if squares.allSatisfy({ $0.status != .empty }) {
            gameOver = true
            winner = .empty
            aiTask?.cancel()
            aiTask = nil
            return true
        }
        
        if !currentPlayer && !gameType {
            aiTask?.cancel()
            aiTask = Task { [weak self] in
                do {
                    try await Task.sleep(for: .seconds(0.5))
                } catch {
                    return
                }
                guard let self, !self.gameOver, self.currentPlayer else { return }
                self.makeAIMove()
                self.hapticTrigger += 1
            }
        }
        
        currentPlayer.toggle()
        
        return true
    }

    
    var boardPositions: [SquareStatus] {
        squares.map { $0.status }
    }
    
    private func makeAIMove() {
        let board = Board(positions: boardPositions, currentTurn: .o, lastMove: -1)
        let bestMove = board.findBestMove()
        
        if bestMove >= 0 && bestMove < squares.count {
            currentPlayer = true
            _ = makeMove(index: bestMove, gameType: true)
        }
    }

    func handlePlayerInput(at index: Int, mode: GameMode) {
        let isPvP = (mode == .pvp)
        if (!currentPlayer && !isPvP) || isPvP {
            _ = makeMove(index: index, gameType: isPvP)
        }
    }
}
