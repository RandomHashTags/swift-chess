//
//  ChessAttack.swift
//
//
//  Created by Evan Anderson on 1/28/25.
//

import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxMacros

enum ChessAttack : ExpressionMacro {
    static func expansion(of node: some FreestandingMacroExpansionSyntax, in context: some MacroExpansionContext) throws -> ExprSyntax {
        let firstTwo = node.arguments.dropLast(1)
        let piece:String
        let white:Bool
        if let string:String = firstTwo.first!.expression.as(MemberAccessExprSyntax.self)?.declName.baseName.text {
            piece = string
            white = true
        } else {
            let function:FunctionCallExprSyntax = firstTwo.first!.expression.as(FunctionCallExprSyntax.self)!
            piece = function.calledExpression.as(MemberAccessExprSyntax.self)!.declName.baseName.text
            white = function.arguments.first!.expression.as(MemberAccessExprSyntax.self)!.declName.baseName.text == "white"
        }
        let file:String = firstTwo.last!.expression.as(MemberAccessExprSyntax.self)!.declName.baseName.text
        let rank:String = node.arguments.last!.expression.as(MemberAccessExprSyntax.self)!.declName.baseName.text
        let value:UInt64 = get(piece: piece, white: white, file: file, rank: rank)
        return "UInt64(\(raw: value))"
    }

    static func position(file: String, rank: String) -> UInt64 {
        return ChessFile.get(text: file) & ChessRank.get(text: rank)
    }

    static func get(piece: String, white: Bool, file: String, rank: String) -> UInt64 {
        switch piece {
        case "pawn":   return pawn(white: white, file: file, rank: rank)
        case "knight": return knight(file: file, rank: rank)
        case "bishop": return bishop(file: file, rank: rank)
        case "rook":   return rook(file: file, rank: rank)
        case "queen":  return queen(file: file, rank: rank)
        case "king":   return king(file: file, rank: rank)
        default:       return 0
        }
    }

    // MARK: Pawn
    static func pawn(white: Bool, file: String, rank: String) -> UInt64 {
        let pos:UInt64 = position(file: file, rank: rank)
        return white ? pos << 9 | pos << 7 : pos >> 7 | pos >> 9
    }

    // MARK: Knight
    static func knight(file: String, rank: String) -> UInt64 {
        let pos:UInt64 = position(file: file, rank: rank)
        var value:UInt64 = pos
        let file:UInt8 = file.first!.asciiValue! - 97
        let rank:UInt8 = rank.last!.asciiValue! - 49
        if file != 0 { // a
            if rank > 1 {
                let closeLeftDown:UInt64 = pos >> 17
                value |= closeLeftDown
                if file != 1 { // b
                    let farLeftDown:UInt64 = pos >> 10
                    value |= farLeftDown
                }
            }
            if rank < 6 {
                let closeLeftUp:UInt64 = pos << 15
                value |= closeLeftUp
                if file != 1 { // b
                    let farLeftUp:UInt64 = pos << 6
                    value |= farLeftUp
                }
            }
        }
        if file != 7 { // h
            if rank > 1 {
                let closeRightDown:UInt64 = pos >> 15
                value |= closeRightDown
                if file != 6 { // g
                    let farRightDown:UInt64 = pos >> 6
                    value |= farRightDown
                }
            }
            if rank < 6 {
                let closeRightUp:UInt64 = pos << 17
                value |= closeRightUp
                if file != 6 { // g
                    let farRightUp:UInt64 = pos << 10
                    value |= farRightUp
                }
            }
        }
        return value & ~pos
    }

    // MARK: Bishop
    static func bishop(file: String, rank: String) -> UInt64 {
        let pos:UInt64 = position(file: file, rank: rank)
        let posFile:Int8 = Int8(file.first!.asciiValue! - 97)
        let posRank:Int8 = Int8(rank.last!.asciiValue! - 49)

        let left:[Int] = [9, 18, 27, 36, 45, 54, 63]
        let right:[Int] = [7, 14, 21, 28, 35, 42, 49]

        var value:UInt64 = pos
        // movement: left
        var freeLeftFiles:Int = Int(posFile)
        var index:Int = 0
        while freeLeftFiles > 0 {
            index += 1
            var newFile = posFile - Int8(index)
            var newRank = posRank + Int8(index)
            if newFile >= 0 && newFile < 8 && newRank < 8 { // up
                value |= pos << right[index-1]
            }

            newFile = posFile - Int8(index)
            newRank = posRank - Int8(index)
            if newFile >= 0 && newFile < 8 && newRank < 8 { // down
                value |= pos >> left[index-1]
            }
            freeLeftFiles -= 1
        }

        // movement: right
        var freeRightFiles:Int = 8 - Int(posFile)
        index = 0
        while freeRightFiles > 0 {
            index += 1
            var newFile = posFile + Int8(index)
            var newRank = posRank + Int8(index)
            if newFile >= 0 && newFile < 8 && newRank < 8 { // up
                value |= pos << left[index-1]
            }

            newFile = posFile + Int8(index)
            newRank = posRank - Int8(index)
            if newFile >= 0 && newFile < 8 && newRank < 8 { // down
                value |= pos >> right[index-1]
            }
            freeRightFiles -= 1
        }
        return value & ~pos
    }

    // MARK: Rook
    static func rook(file: String, rank: String) -> UInt64 {
        let pos:UInt64 = position(file: file, rank: rank)
        return (ChessFile.get(text: file) | ChessRank.get(text: rank)) & ~pos
    }

    // MARK: Queen
    static func queen(file: String, rank: String) -> UInt64 {
        return bishop(file: file, rank: rank) | rook(file: file, rank: rank)
    }

    // MARK: King
    static func king(file: String, rank: String) -> UInt64 {
        let pos:UInt64 = position(file: file, rank: rank)
        var value:UInt64 = pos

        let notAFile:Bool = pos & ChessFile.get(text: "notA") > 0
        let notHFile:Bool = pos & ChessFile.get(text: "notH") > 0
        if notAFile {
            value |= pos >> 1 // middle left
        }
        if notHFile {
            value |= pos << 1 // middle right
        }
        if pos & ChessRank.get(text: "_8") == 0 { // up
            if notAFile {
                value |= pos << 7 // left
            }
            value |= pos << 8 // middle
            if notHFile {
                value |= pos << 9 // right
            }
        }
        if pos & ChessRank.get(text: "_1") == 0 { // down
            if notAFile {
                value |= pos >> 9 // left
            }
            value |= pos >> 8 // middle
            if notHFile {
                value |= pos >> 7 // right
            }
        }
        return value & ~pos
    }
}