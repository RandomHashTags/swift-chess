//
//  ChessBitMap.swift
//
//
//  Created by Evan Anderson on 1/26/25.
//

public enum ChessBitMap {
    case empty
    case newGame
    case universal

    case startingPositions(forPiece: ChessPiece, forWhite: Bool)
}