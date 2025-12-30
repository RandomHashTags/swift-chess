
import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct SwiftChessMacros: CompilerPlugin {
    let providingMacros:[any Macro.Type] = [
        ChessFile.self,
        ChessRank.self,
        ChessAttack.self,
        ChessBitMap.self
    ]
}