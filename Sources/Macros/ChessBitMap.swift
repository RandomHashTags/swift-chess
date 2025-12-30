
import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxMacros

enum ChessBitMap: ExpressionMacro {
    static func expansion(of node: some FreestandingMacroExpansionSyntax, in context: some MacroExpansionContext) throws -> ExprSyntax {
        let text = node.arguments.last?.expression.as(MemberAccessExprSyntax.self)?.declName.baseName.text
                            ?? node.arguments.last?.expression.as(FunctionCallExprSyntax.self)?.description
        let value = get(text: text)
        return "UInt64(\(raw: value))"
    }

    static func get(text: String?) -> UInt64 {
        var values = text?.split(separator: "(")
        switch values?[0] {
        case "empty":
            return 0
        case "newGame":
            return 18446462598732906495
        case "universal":
            return UInt64.max
        case ".startingPositions":
            let text = text!
            values = text[text.index(text.startIndex, offsetBy: values![0].count+1)...].split(separator: ",")
            var piece = values![0].split(separator: " ")[1]
            piece = piece[piece.index(after: piece.startIndex)...]
            return startingPositions(for: piece, forWhite: values![1].hasSuffix("true)"))
        default:
            return 0
        }
    }

    static func startingPositions(
        for piece: some StringProtocol,
        forWhite: Bool
    ) -> UInt64 {
        if forWhite {
            switch piece {
            case "pawn":   return 65280
            case "rook":   return 129
            case "knight": return 66
            case "bishop": return 36
            case "queen":  return 8
            case "king":   return 16
            default:       return 0
            }
        }
        // black
        switch piece {
        case "pawn": return 71776119061217280
        case "rook": return 9295429630892703744
        case "knight": return 4755801206503243776
        case "bishop": return 2594073385365405696
        case "queen": return 1152921504606846976
        case "king": return 576460752303423488
        default: return 0
        }
    }
}