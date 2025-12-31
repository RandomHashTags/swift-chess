
import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct SwiftChessMacros: CompilerPlugin {
    let providingMacros:[any Macro.Type] = [
        PositionalAttacks.self,
        ChessBitMap.self
    ]
}