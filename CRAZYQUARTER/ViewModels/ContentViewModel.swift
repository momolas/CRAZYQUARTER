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
final class ContentViewModel {
    var popup: Bool = false
    var mode: GameMode = .ai
}
