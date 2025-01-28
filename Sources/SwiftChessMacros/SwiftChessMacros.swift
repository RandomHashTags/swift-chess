//
//  SwiftChessMacros.swift
//
//
//  Created by Evan Anderson on 1/26/25.
//

import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct SwiftChessMacros : CompilerPlugin {
    let providingMacros:[any Macro.Type] = [
        ChessFile.self,
        ChessRank.self,
        ChessAttack.self
    ]
}