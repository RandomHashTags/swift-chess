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
        var value:UInt64 = 0
        let text:String? = node.arguments.first?.expression.as(MemberAccessExprSyntax.self)?.declName.baseName.text
        switch text {
        case "rook":   value = rook(file: "a", rank: "_1")
        default:       break
        }
        return "UInt64(\(raw: value))"
    }

    static func get(piece: String, file: String, rank: String) -> UInt64 {
        switch piece {
        case "rook": return rook(file: file, rank: rank)
        default: return 0
        }
    }
    static func rook(file: String, rank: String) -> UInt64 {
        return ChessFile.get(text: file) | ChessRank.get(text: rank)
    }
}