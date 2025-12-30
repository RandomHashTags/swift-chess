
import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct SwiftChessMacros: CompilerPlugin {
    let providingMacros:[any Macro.Type] = [
        ChessAttack.self,
        ChessBitMap.self
    ]
}