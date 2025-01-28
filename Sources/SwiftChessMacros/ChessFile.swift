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
        let text:String? = node.arguments.last?.expression.as(MemberAccessExprSyntax.self)?.declName.baseName.text
        let value:UInt64 = get(text: text)
        return "UInt64(\(raw: value))"
    }

    static func get(text: String?) -> UInt64 {
        var value:UInt64 = 0x0101010101010101
        switch text?.last {
        case "b", "B": value <<= 1
        case "c", "C": value <<= 2
        case "d", "D": value <<= 3
        case "e", "E": value <<= 4
        case "f", "F": value <<= 5
        case "g", "G": value <<= 6
        case "h", "H": value <<= 7
        default:  break
        }
        if text?.last?.isUppercase ?? false {
            value = ~value
        }
        return value
    }
}