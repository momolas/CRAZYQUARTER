//
//  TicTacToeModelTests.swift
//  CRAZYQUARTERTests
//
//  Created by Jules on 18/03/2024.
//

import XCTest
@testable import CRAZYQUARTER

@MainActor
final class TicTacToeModelTests: XCTestCase {

    func testInitialization() {
        let model = TicTacToeModel(currentPlayer: false)
        XCTAssertEqual(model.squares.count, 9)
        XCTAssertTrue(model.squares.allSatisfy { $0.squareStatus == .empty })
        XCTAssertFalse(model.currentPlayer) // X
        XCTAssertFalse(model.gameOver)
    }

    func testSquaresAreDistinct() {
        let model = TicTacToeModel(currentPlayer: false)
        model.squares[0].squareStatus = .x
        XCTAssertEqual(model.squares[0].squareStatus, .x)
        XCTAssertEqual(model.squares[1].squareStatus, .empty) // Ensure other square is not affected
    }

    func testMakeMove() {
        let model = TicTacToeModel(currentPlayer: false)
        let success = model.makeMove(index: 0, gameType: true) // PvP

        XCTAssertTrue(success)
        XCTAssertEqual(model.squares[0].squareStatus, .x)
        XCTAssertTrue(model.currentPlayer) // Toggled to O (true)
    }

    func testMakeMoveO() {
        let model = TicTacToeModel(currentPlayer: true) // O starts
        let success = model.makeMove(index: 4, gameType: true)

        XCTAssertTrue(success)
        XCTAssertEqual(model.squares[4].squareStatus, .o)
        XCTAssertFalse(model.currentPlayer) // Toggled to X (false)
    }

    func testWinDetection() {
        let model = TicTacToeModel(currentPlayer: false)

        // X moves 0
        _ = model.makeMove(index: 0, gameType: true)
        // O moves 3
        _ = model.makeMove(index: 3, gameType: true)
        // X moves 1
        _ = model.makeMove(index: 1, gameType: true)
        // O moves 4
        _ = model.makeMove(index: 4, gameType: true)
        // X moves 2 (Wins)
        _ = model.makeMove(index: 2, gameType: true)

        XCTAssertTrue(model.gameOver)
        XCTAssertEqual(model.winner, .x)
    }

    func testDrawDetection() {
        let model = TicTacToeModel(currentPlayer: false)

        // Fill board without winner
        // X O X
        // X O X
        // O X O

        let moves = [0, 1, 2, 4, 3, 5, 7, 6, 8]
        // 0: X (0)
        // 1: O (1)
        // 2: X (2) -> X X X ? No wait logic above.

        // Let's brute force set
        model.squares[0].squareStatus = .x
        model.squares[1].squareStatus = .o
        model.squares[2].squareStatus = .x

        model.squares[3].squareStatus = .x
        model.squares[4].squareStatus = .o
        model.squares[5].squareStatus = .x

        model.squares[6].squareStatus = .o
        model.squares[7].squareStatus = .x
        // 8 is empty

        // Make last move at 8
        // Current player should be O (if we alternated properly, but we set manually)
        // Let's say current player is O
        model.currentPlayer = true
        _ = model.makeMove(index: 8, gameType: true)

        // 8 becomes O
        // Board:
        // X O X
        // X O X
        // O X O

        // Check cols
        // 0,3,6: X, X, O
        // 1,4,7: O, O, X
        // 2,5,8: X, X, O
        // Diags:
        // 0,4,8: X, O, O
        // 2,4,6: X, O, O

        XCTAssertTrue(model.gameOver)
        XCTAssertEqual(model.winner, .empty)
    }
}
