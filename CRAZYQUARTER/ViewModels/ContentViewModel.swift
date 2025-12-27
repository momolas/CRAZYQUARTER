//
//  ContentViewModel.swift
//  CRAZYQUARTER
//
//  Created by Mo on 18/03/2024.
//

import Foundation
import SwiftUI
import Observation

@Observable
@MainActor
class ContentViewModel {
    var popup: Bool = false
    var selection: Bool = false // Game mode: false = AI, true = PvP
}
