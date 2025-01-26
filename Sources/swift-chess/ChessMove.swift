//
//  ChessMove.swift
//
//
//  Created by Evan Anderson on 1/26/25.
//

struct ChessMove : Hashable, Sendable {
    let from:ChessPosition
    let to:ChessPosition
    let promotion:ChessPiece?

    init(from: ChessPosition, to: ChessPosition, promotion: ChessPiece? = nil) {
        self.from = from
        self.to = to
        self.promotion = promotion
    }

    var distance : (files: Int, ranks: Int) {
        return from.distance(to: to)
    }
}

extension ChessMove {
    struct Result : Sendable {
        let captured:ChessPiece.Active?
        let promotion:ChessPiece?
        let opponentInCheck:Bool
        let opponentWasCheckmated:Bool
    }
}

extension ChessMove {
    enum Annotation : Sendable{
        case blunder
        case check
        case checkmate
        case dubious
        case excellent
        case good
        case interesting
        case mistake

        var symbol : String {
            switch self {
            case .blunder: return "??"
            case .check: return "+"
            case .checkmate: return "#"
            case .dubious: return "?!"
            case .excellent: return "!!"
            case .good: return "!"
            case .interesting: return "!?"
            case .mistake: return "?"
            }
        }
    }
}