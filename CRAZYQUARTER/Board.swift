//
//  Board.swift
//  CRAZYQUARTER
//
//  Created by Mo on 18/03/2024.
//

import Foundation
import SwiftUI

struct Board {
    let positions: [SquareStatus] // Renamed for clarity
    let currentTurn: SquareStatus
    let lastMove: Int
    let opposite: SquareStatus
    
    init(positions: [SquareStatus] = [.empty, .empty, .empty, .empty, .empty, .empty, .empty, .empty, .empty],
         currentTurn: SquareStatus = .x,
         lastMove: Int = -1) {
        self.positions = positions
        self.currentTurn = currentTurn
        self.lastMove = lastMove
        self.opposite = currentTurn == .x ? .o : .x
    }
    
    func move(_ location: Int) -> Board {
        var newPositions = positions
        newPositions[location] = currentTurn
        return Board(positions: newPositions, currentTurn: opposite, lastMove: location)
    }
    
    var availableMoves: [Int] {
        return positions.indices.filter { positions[$0] == .empty }
    }
    
    var isWin: Bool {
        let lines = [
            [0, 1, 2], [3, 4, 5], [6, 7, 8],
            [0, 3, 6], [1, 4, 7], [2, 5, 8],
            [0, 4, 8], [2, 4, 6]
        ]
        
        for line in lines {
            let squares = line.map { positions[$0] }
            if squares.allSatisfy({ $0 == currentTurn }) {
                return true
            }
        }
        
        return false
    }
    
    var isDraw: Bool {
        return !isWin && availableMoves.isEmpty
    }
    
    func minimax(maximizing: Bool, originalPlayer: SquareStatus, alpha: Int = Int.min, beta: Int = Int.max) -> Int {
        if isWin && originalPlayer == opposite {
            return 1
        } else if isWin && originalPlayer != opposite {
            return -1
        } else if isDraw {
            return 0
        }
        
        var bestScore: Int = maximizing ? alpha : beta
        
        for availableMove in availableMoves {
            let newBoard = move(availableMove)
            
            let score = minimax(maximizing: !maximizing, originalPlayer: originalPlayer, alpha: alpha, beta: beta)
            
            if maximizing {
                bestScore = max(bestScore, score)
                if bestScore >= beta {
                    break // Alpha-beta pruning
                }
            } else {
                bestScore = min(bestScore, score)
                if bestScore <= alpha {
                    break // Alpha-beta pruning
                }
            }
        }
        
        return bestScore
    }
    
    func findBestMove() -> Int {
        var bestScore: Int = Int.min
        var bestMove: Int = -1
        
        for availableMove in availableMoves {
            let score = minimax(maximizing: false, originalPlayer: currentTurn)
            
            if score > bestScore {
                bestScore = score
                bestMove = availableMove
            }
        }
        
        return bestMove
    }
}
