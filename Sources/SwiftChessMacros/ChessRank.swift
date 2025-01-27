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
        var value:UInt8 = 0b00000001
        switch node.arguments.first?.expression.as(MemberAccessExprSyntax.self)?.declName.baseName.text {
            case "_2": value <<= 1
            case "_3": value <<= 2
            case "_4": value <<= 3
            case "_5": value <<= 4
            case "_6": value <<= 5
            case "_7": value <<= 6
            case "_8": value <<= 7
            default:   break
        }
        return "UInt8(\(raw: value))"
    }
}