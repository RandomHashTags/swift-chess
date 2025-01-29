//
//  ChessRank.swift
//
//
//  Created by Evan Anderson on 1/26/25.
//

import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxMacros

enum ChessRank : ExpressionMacro {
    static func expansion(of node: some FreestandingMacroExpansionSyntax, in context: some MacroExpansionContext) throws -> ExprSyntax {
        let value:UInt64 = get(text: node.arguments.first?.expression.as(MemberAccessExprSyntax.self)?.declName.baseName.text)
        return "UInt64(\(raw: value))"
    }

    static func get(text: String?) -> UInt64 {
        var value:UInt64 = 0b0000000000000000000000000000000000000000000000000000000011111111
        switch text {
        case "_1": break
        case "_2": value <<= 8
        case "_3": value <<= 16
        case "_4": value <<= 24
        case "_5": value <<= 32
        case "_6": value <<= 40
        case "_7": value <<= 48
        case "_8": value <<= 56
        default:   return 0
        }
        return value
    }
}