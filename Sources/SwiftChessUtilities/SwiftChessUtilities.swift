//
//  SwiftChessUtilities.swift
//
//
//  Created by Evan Anderson on 1/26/25.
//

// MARK: File
public enum ChessFile {
    case a
    case b
    case c
    case d
    case e
    case f
    case g
    case h

    case notA
    case notB
    case notC
    case notD
    case notE
    case notF
    case notG
    case notH
}

@freestanding(expression)
public macro chessFile(_ file: ChessFile) -> UInt64 = #externalMacro(module: "SwiftChessMacros", type: "ChessFile")

// MARK: Rank
public enum ChessRank {
    case _1
    case _2
    case _3
    case _4
    case _5
    case _6
    case _7
    case _8
}

@freestanding(expression)
public macro chessRank(_ rank: ChessRank) -> UInt64 = #externalMacro(module: "SwiftChessMacros", type: "ChessRank")

// MARK: Attack
@freestanding(expression)
public macro chessAttack(piece: ChessPiece, file: ChessFile, rank: ChessRank) -> UInt64 = #externalMacro(module: "SwiftChessMacros", type: "ChessAttack")