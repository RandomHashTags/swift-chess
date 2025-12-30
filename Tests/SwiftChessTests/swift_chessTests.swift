//
//  swift_chessTests.swift
//
//
//  Created by Evan Anderson on 1/26/25.
//

#if compiler(>=6.0)

import Testing
@testable import SwiftChessUtilities

struct SwiftChessTests {
    let game:ChessGame = ChessGame(chessClock: nil, board: ChessBoard(), player1: .white, player2: .black, firstMove: .white)

    @Test func fileMacro() {
        #expect(#chessFile(.a) == 0b0000000100000001000000010000000100000001000000010000000100000001)
        #expect(#chessFile(.b) == 0b0000001000000010000000100000001000000010000000100000001000000010)
        #expect(#chessFile(.c) == 0b0000010000000100000001000000010000000100000001000000010000000100)

        #expect(#chessFile(.h) == 0b1000000010000000100000001000000010000000100000001000000010000000)
        #expect(#chessFile(.g) == 0b0100000001000000010000000100000001000000010000000100000001000000)
    }

    @Test func notFileMacro() {
        #expect(#chessFile(.notA) == 0b1111111011111110111111101111111011111110111111101111111011111110)
        #expect(#chessFile(.notH) == 0b0111111101111111011111110111111101111111011111110111111101111111)
    }

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
        var piece ChessPiece.Active(piece: .pawn, owner: .white, firstMove: true)
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
        var piece ChessPiece.Active(piece: .bishop, owner: .white, firstMove: true)
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
        var piece ChessPiece.Active(piece: .rook, owner: .white, firstMove: true)
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

#endif

func binary(_ number: UInt64) -> String {
    let string:String = String.init(number, radix: 2)
    let padded:String = String(repeating: "0", count: 64 - string.count) + string
    var s:String = ""
    var lastIndex:String.Index = padded.startIndex
    for _ in 0..<8 {
        let slice = padded[lastIndex..<padded.index(lastIndex, offsetBy: 8)].reversed()
        s += "\n" + slice
        padded.formIndex(&lastIndex, offsetBy: 8)
    }
    return "\n" + s
}
func bitMapComment(expected: UInt64, actual: UInt64) -> Comment {
    return Comment(rawValue: "expected=" + binary(expected) + "\nactual=" + binary(actual))
}