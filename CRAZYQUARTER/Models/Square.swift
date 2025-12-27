//
//  Square.swift
//  CRAZYQUARTER
//
//  Created by Mo on 18/03/2024.
//

import Foundation
import SwiftUI
import Observation

enum SquareStatus {
    case empty, x, o, xw, ow
}

@Observable
@MainActor
class Square {
    var squareStatus: SquareStatus
    
    init(status: SquareStatus) {
        self.squareStatus = status
    }
}
