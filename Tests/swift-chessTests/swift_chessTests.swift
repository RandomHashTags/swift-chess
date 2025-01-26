//
//  swift_chessTests.swift
//
//
//  Created by Evan Anderson on 1/26/25.
//

import Testing
@testable import swift_chess

struct SwiftChessTests {
    let game:ChessGame = ChessGame(chessClock: nil, board: ChessBoard(), player1: .white, player2: .black, firstMove: .white)

    @Test func positionDistance() {
        var one:ChessPosition = ChessPosition(file: 4, rank: 0)
        var two:ChessPosition = ChessPosition(file: 4, rank: 3)
        var distance:(Int, Int) = one.distance(to: two)
        #expect(distance == (0, 3))

        two = ChessPosition(file: 5, rank: 1)
        distance = one.distance(to: two)
        #expect(distance == (1, 1))
    }

    @Test func pawnFirstMoves() {
        // white
        var player:ChessPlayer = .white
        var piece:ChessPiece.Active = ChessPiece.Active(piece: .pawn, owner: .white, firstMove: true)
        var from:ChessPosition = ChessPosition(file: 0, rank: 1)
        var to:ChessPosition = ChessPosition(file: 0, rank: 3)
        #expect(player.canMove(piece, from: from, to: to, for: game))

        piece.firstMove = false
        #expect(!player.canMove(piece, from: from, to: to, for: game))

        to = ChessPosition(file: 0, rank: 2)
        #expect(player.canMove(piece, from: from, to: to, for: game))

        // black
        player = .black
        piece.owner = .black
        piece.firstMove = true
        from = ChessPosition(file: 0, rank: 6)
        to = ChessPosition(file: 0, rank: 4)
        #expect(player.canMove(piece, from: from, to: to, for: game))

        piece.firstMove = false
        #expect(!player.canMove(piece, from: from, to: to, for: game))

        to = ChessPosition(file: 0, rank: 5)
        #expect(player.canMove(piece, from: from, to: to, for: game))
    }

    @Test func bishopMoves() {
        // white
        var game:ChessGame = game
        var player:ChessPlayer = .white
        var piece:ChessPiece.Active = ChessPiece.Active(piece: .bishop, owner: .white, firstMove: true)
        var from:ChessPosition = ChessPosition(file: 2, rank: 0)
        var to:ChessPosition = ChessPosition(file: 3, rank: 1)
        #expect(!player.canMove(piece, from: from, to: to, for: game))

        game.positions[ChessPosition(file: 3, rank: 1)] = nil
        #expect(player.canMove(piece, from: from, to: to, for: game))
    }

    @Test func rookMoves() {
        // white
        var game:ChessGame = game
        var player:ChessPlayer = .white
        var piece:ChessPiece.Active = ChessPiece.Active(piece: .rook, owner: .white, firstMove: true)
        var from:ChessPosition = ChessPosition(file: 0, rank: 0)
        var to:ChessPosition = ChessPosition(file: 0, rank: 3)
        #expect(!player.canMove(piece, from: from, to: to, for: game))

        game.positions[ChessPosition(file: 0, rank: 1)] = nil
        #expect(player.canMove(piece, from: from, to: to, for: game))

        game.positions[ChessPosition(file: 1, rank: 0)] = nil
        game.positions[ChessPosition(file: 1, rank: 1)] = nil
        to = ChessPosition(file: 1, rank: 1)
        #expect(!player.canMove(piece, from: from, to: to, for: game))
    }

    @Test func checkStatus() {
        var game:ChessGame = game
        #expect(game.thinking == .white)
        
        game.positions = [:]
        game.positions[ChessPosition(file: 3, rank: 3)] = ChessPiece.Active(piece: .king, owner: .white, firstMove: false)
        game.positions[ChessPosition(file: 3, rank: 6)] = ChessPiece.Active(piece: .rook, owner: .black, firstMove: false)
        game.calculateCheckStatus()

        #expect(game.inCheck)
    }

    /*
    @Test func example() {
        game.display()
    }
    */
}