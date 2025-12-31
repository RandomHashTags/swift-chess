import ChessUtilities
import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxMacros

enum LegalMoves: ExpressionMacro {
    static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) throws -> ExprSyntax {
        ""
    }
}

extension LegalMoves {
    static func excludeUpLeftDiagonals(_ bitmap: inout BitMap) {
        bitmap &= ~(bitmap << 9 | bitmap << 18 | bitmap << 27 | bitmap << 36 | bitmap << 45 | bitmap << 54 | bitmap << 63)
    }
    static func excludeUpRightDiagonals(_ bitmap: inout BitMap) {
        bitmap &= ~(bitmap << 7 | bitmap << 14 | bitmap << 21 | bitmap << 28 | bitmap << 35 | bitmap << 42 | bitmap << 49)
    }
    
    static func excludeDownLeftDiagonals(_ bitmap: inout BitMap) {
        bitmap &= ~(bitmap >> 7 | bitmap >> 14 | bitmap >> 21 | bitmap >> 28 | bitmap >> 35 | bitmap >> 42 | bitmap >> 49)
    }
    static func excludeDownRightDiagonals(_ bitmap: inout BitMap) {
        bitmap &= ~(bitmap >> 9 | bitmap >> 18 | bitmap >> 27 | bitmap >> 36 | bitmap >> 45 | bitmap >> 54 | bitmap >> 63)
    }
}