//
//  GameMode.swift
//  CRAZYQUARTER
//
//  Created by Mo on 08/09/2026.
//

import Foundation

enum GameMode: String, CaseIterable, Identifiable, Sendable {
    case ai = "IA"
    case pvp = "PvP"
    
    var id: Self { self }
}
