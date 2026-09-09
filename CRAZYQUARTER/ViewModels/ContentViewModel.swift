//
//  ContentViewModel.swift
//  CRAZYQUARTER
//
//  Created by Mo on 18/03/2024.
//

import Foundation
import Observation

@Observable
@MainActor
final class ContentViewModel {
    var popup: Bool = false
    var mode: GameMode = .ai
    
    func turnMessage(currentPlayer: Bool) -> String {
        if mode == .pvp {
            let player = !currentPlayer ? "X" : "O"
            return "À \(player) de jouer"
        } else {
            let player = !currentPlayer ? "vous" : "l'IA"
            return "À \(player) de jouer"
        }
    }
    
    func gameOverMessage(winner: SquareStatus) -> String {
        if mode == .ai {
            switch winner {
            case .x, .xw:
                return "Vous avez gagné !"
            case .o, .ow:
                return "L'IA a gagné !"
            default:
                return "Match nul !"
            }
        } else {
            switch winner {
            case .x, .xw:
                return "X a gagné !"
            case .o, .ow:
                return "O a gagné !"
            default:
                return "Match nul !"
            }
        }
    }
}
