//
//  ChessMoveError.swift
//
//
//  Created by Evan Anderson on 1/26/25.
//

public enum ChessMoveError : Error {
    case illegal(String)
    case pieceNotFoundForPosition(ChessPosition)
    case cannotMoveOpponentPiece
    case unrecognized(any StringProtocol)
}