//
//  TicTacToeModelTests.swift
//  CRAZYQUARTERTests
//
//  Created by Jules on 18/03/2024.
//

import Testing
@testable import CRAZYQUARTER

@MainActor
struct TicTacToeModelTests {

    // MARK: - TicTacToeModel Tests

    @Test func initialization() {
        let model = TicTacToeModel(currentPlayer: false)
        #expect(model.squares.count == 9)
        #expect(model.squares.allSatisfy { $0.status == .empty })
        #expect(!model.currentPlayer) // X
        #expect(!model.gameOver)
        #expect(model.winner == .empty)
    }

    @Test func makeMoveX() {
        let model = TicTacToeModel(currentPlayer: false)
        let success = model.makeMove(index: 0, gameType: true) // PvP

        #expect(success)
        #expect(model.squares[0].status == .x)
        #expect(model.currentPlayer) // Toggled to O (true)
    }

    @Test func makeMoveO() {
        let model = TicTacToeModel(currentPlayer: true) // O starts
        let success = model.makeMove(index: 4, gameType: true)

        #expect(success)
        #expect(model.squares[4].status == .o)
        #expect(!model.currentPlayer) // Toggled to X (false)
    }

    @Test func makeMoveOnOccupiedSquare() {
        let model = TicTacToeModel(currentPlayer: false)
        _ = model.makeMove(index: 0, gameType: true)
        let secondMoveSuccess = model.makeMove(index: 0, gameType: true)

        #expect(!secondMoveSuccess)
        #expect(model.squares[0].status == .x)
    }

    @Test func winDetection() {
        let model = TicTacToeModel(currentPlayer: false)

        _ = model.makeMove(index: 0, gameType: true) // X
        _ = model.makeMove(index: 3, gameType: true) // O
        _ = model.makeMove(index: 1, gameType: true) // X
        _ = model.makeMove(index: 4, gameType: true) // O
        _ = model.makeMove(index: 2, gameType: true) // X wins

        #expect(model.gameOver)
        #expect(model.winner == .x)
    }

    @Test func drawDetection() {
        let model = TicTacToeModel(currentPlayer: false)

        // Set up board for a draw:
        // X O X
        // X O X
        // O X .
        model.squares[0].status = .x
        model.squares[1].status = .o
        model.squares[2].status = .x

        model.squares[3].status = .x
        model.squares[4].status = .o
        model.squares[5].status = .x

        model.squares[6].status = .o
        model.squares[7].status = .x

        model.currentPlayer = true // O plays last move
        let success = model.makeMove(index: 8, gameType: true)

        #expect(success)
        #expect(model.gameOver)
        #expect(model.winner == .empty)
    }

    @Test func resetGame() {
        let model = TicTacToeModel(currentPlayer: false)
        _ = model.makeMove(index: 0, gameType: true)
        _ = model.makeMove(index: 1, gameType: true)

        model.resetGame()

        #expect(model.squares.allSatisfy { $0.status == .empty })
        #expect(!model.currentPlayer)
        #expect(!model.gameOver)
        #expect(model.winner == .empty)
    }

    // MARK: - Board Model Tests

    @Test func boardInitialState() {
        let board = Board()
        #expect(board.positions.count == 9)
        #expect(board.availableMoves.count == 9)
        #expect(!board.isWin)
        #expect(!board.isDraw)
    }

    @Test func boardMoveAndAlternateTurn() {
        let board = Board()
        let nextBoard = board.move(4)

        #expect(nextBoard.positions[4] == .x)
        #expect(nextBoard.currentTurn == .o)
        #expect(nextBoard.lastMove == 4)
        #expect(nextBoard.availableMoves.count == 8)
    }

    @Test func boardWinDetectionHorizontal() {
        let positions: [SquareStatus] = [
            .x, .x, .x,
            .empty, .empty, .empty,
            .empty, .empty, .empty
        ]
        let board = Board(positions: positions, currentTurn: .o, lastMove: 2)
        #expect(board.isWin)
    }

    @Test func boardAIWinsWhenImmediateOpportunityExists() {
        // O needs 1 move to win at index 2:
        // O O .
        // X X .
        // . . .
        let positions: [SquareStatus] = [
            .o, .o, .empty,
            .x, .x, .empty,
            .empty, .empty, .empty
        ]
        let board = Board(positions: positions, currentTurn: .o, lastMove: 4)
        let bestMove = board.findBestMove()
        #expect(bestMove == 2)
    }

    @Test func boardAIBlocksOpponentWinningMove() {
        // X is about to win at index 2:
        // X X .
        // O . .
        // . . .
        let positions: [SquareStatus] = [
            .x, .x, .empty,
            .o, .empty, .empty,
            .empty, .empty, .empty
        ]
        let board = Board(positions: positions, currentTurn: .o, lastMove: 1)
        let bestMove = board.findBestMove()
        #expect(bestMove == 2)
    }

    // MARK: - ContentViewModel Tests

    @Test func contentViewModelTurnMessages() {
        let vm = ContentViewModel()
        vm.mode = .pvp
        #expect(vm.turnMessage(currentPlayer: false) == "À X de jouer")
        #expect(vm.turnMessage(currentPlayer: true) == "À O de jouer")

        vm.mode = .ai
        #expect(vm.turnMessage(currentPlayer: false) == "À vous de jouer")
        #expect(vm.turnMessage(currentPlayer: true) == "À l'IA de jouer")
    }

    @Test func contentViewModelGameOverMessages() {
        let vm = ContentViewModel()
        vm.mode = .ai
        #expect(vm.gameOverMessage(winner: .x) == "Vous avez gagné !")
        #expect(vm.gameOverMessage(winner: .o) == "L'IA a gagné !")
        #expect(vm.gameOverMessage(winner: .empty) == "Match nul !")

        vm.mode = .pvp
        #expect(vm.gameOverMessage(winner: .x) == "X a gagné !")
        #expect(vm.gameOverMessage(winner: .o) == "O a gagné !")
        #expect(vm.gameOverMessage(winner: .empty) == "Match nul !")
    }
}
