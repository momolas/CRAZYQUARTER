//
//  Square.swift
//  CRAZYQUARTER
//
//  Created by Mo on 18/03/2024.
//

import Foundation
import SwiftUI

enum SquareStatus {
    case empty, x, o, xw, ow
}

class Square : ObservableObject {
    @Published var squareStatus: SquareStatus
    
    init(status: SquareStatus) {
        self.squareStatus = status
    }
}
