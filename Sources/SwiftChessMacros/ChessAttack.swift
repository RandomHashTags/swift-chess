//
//  ChessAttack.swift
//
//
//  Created by Evan Anderson on 1/28/25.
//

import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxMacros

enum ChessAttack : ExpressionMacro {
    static func expansion(of node: some FreestandingMacroExpansionSyntax, in context: some MacroExpansionContext) throws -> ExprSyntax {
        let firstTwo = node.arguments.dropLast(1)
        let piece:String = firstTwo.first!.expression.as(MemberAccessExprSyntax.self)!.declName.baseName.text
        let file:String = firstTwo.last!.expression.as(MemberAccessExprSyntax.self)!.declName.baseName.text
        let rank:String = node.arguments.last!.expression.as(MemberAccessExprSyntax.self)!.declName.baseName.text
        let value:UInt64 = get(piece: piece, file: file, rank: rank)
        return "UInt64(\(raw: value))"
    }

    static func position(file: String, rank: String) -> UInt64 {
        return ChessFile.get(text: file) & ChessRank.get(text: rank)
    }

    static func get(piece: String, file: String, rank: String) -> UInt64 {
        switch piece {
        case "pawn":   return pawn(file: file, rank: rank)
        case "bishop": return bishop(file: file, rank: rank)
        case "rook":   return rook(file: file, rank: rank)
        case "queen":  return queen(file: file, rank: rank)
        default:       return 0
        }
    }

    static func pawn(file: String, rank: String) -> UInt64 {
        let pos:UInt64 = position(file: file, rank: rank)
        return pos << 9 | pos << 7
    }
    static func bishop(file: String, rank: String) -> UInt64 {
        let pos:UInt64 = position(file: file, rank: rank)
        var value:UInt64 = pos
        // left up and right down diagonal
        for i in [9, 18, 27, 36, 45, 54, 63] {
            value |= pos << i
            //value |= pos >> i
        }
        // right up and left down diagonal
        for i in [7, 14, 21, 28, 35, 42, 49] {
            //value |= pos << i
            value |= pos >> i
        }
        return value & ~pos
    }
    static func rook(file: String, rank: String) -> UInt64 {
        let pos:UInt64 = position(file: file, rank: rank)
        return (ChessFile.get(text: file) | ChessRank.get(text: rank)) & ~pos
    }
    static func queen(file: String, rank: String) -> UInt64 {
        return bishop(file: file, rank: rank) | rook(file: file, rank: rank)
    }
}