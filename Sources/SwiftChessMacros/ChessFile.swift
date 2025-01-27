//
//  ChessFile.swift
//
//
//  Created by Evan Anderson on 1/26/25.
//

import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxMacros

enum ChessFile : ExpressionMacro {
    static func expansion(of node: some FreestandingMacroExpansionSyntax, in context: some MacroExpansionContext) throws -> ExprSyntax {
        let value:UInt64
        switch node.arguments.last?.expression.as(MemberAccessExprSyntax.self)?.declName.baseName.text {
            case "b": value = 4629771061636907072
            case "c": value = 2314885530818453536
            case "d": value = 1157442765409226768
            case "e": value = 578721382704613384
            case "f": value = 289360691352306692
            case "g": value = 144680345676153346
            case "h": value = 72340172838076673
            default:  value = 9259542123273814144
        }
        return "UInt64(\(raw: value))"
    }
}