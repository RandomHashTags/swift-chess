
import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxMacros

enum ChessAttack: ExpressionMacro {
    static func expansion(of node: some FreestandingMacroExpansionSyntax, in context: some MacroExpansionContext) throws -> ExprSyntax {
        var piece = "pawn"
        var white = true
        var file = "0"
        var rank = "0"
        for argument in node.arguments {
            switch argument.label?.text {
            case "player":
                white = argument.expression.as(MemberAccessExprSyntax.self)?.declName.baseName.text == "white"
            case "piece":
                piece = argument.expression.as(MemberAccessExprSyntax.self)?.declName.baseName.text ?? "pawn"
            case "file":
                file = argument.expression.as(MemberAccessExprSyntax.self)?.declName.baseName.text ?? "0"
            case "rank":
                rank = argument.expression.as(MemberAccessExprSyntax.self)?.declName.baseName.text ?? "0"
            default:
                break
            }
        }
        let value = get(piece: piece, white: white, file: file, rank: rank)
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
        let pos = position(file: file, rank: rank)
        return white ? pos << 9 | pos << 7 : pos >> 7 | pos >> 9
    }

    // MARK: Knight
    static func knight(file: String, rank: String) -> UInt64 {
        let pos = position(file: file, rank: rank)
        var value = pos
        let file = file.first!.asciiValue! - 97
        let rank = rank.last!.asciiValue! - 49
        if file != 0 { // a
            if rank > 1 {
                let closeLeftDown = pos >> 17
                value |= closeLeftDown
                if file != 1 { // b
                    let farLeftDown = pos >> 10
                    value |= farLeftDown
                }
            }
            if rank < 6 {
                let closeLeftUp = pos << 15
                value |= closeLeftUp
                if file != 1 { // b
                    let farLeftUp = pos << 6
                    value |= farLeftUp
                }
            }
        }
        if file != 7 { // h
            if rank > 1 {
                let closeRightDown = pos >> 15
                value |= closeRightDown
                if file != 6 { // g
                    let farRightDown = pos >> 6
                    value |= farRightDown
                }
            }
            if rank < 6 {
                let closeRightUp = pos << 17
                value |= closeRightUp
                if file != 6 { // g
                    let farRightUp = pos << 10
                    value |= farRightUp
                }
            }
        }
        return value & ~pos
    }

    // MARK: Bishop
    static func bishop(file: String, rank: String) -> UInt64 {
        let pos = position(file: file, rank: rank)
        let posFile = Int8(file.first!.asciiValue! - 97)
        let posRank = Int8(rank.last!.asciiValue! - 49)

        let left:[_ of Int] = [9, 18, 27, 36, 45, 54, 63]
        let right:[_ of Int] = [7, 14, 21, 28, 35, 42, 49]

        var value = pos
        // movement: left
        var freeLeftFiles = Int(posFile)
        var index = 0
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
        var freeRightFiles = 8 - Int(posFile)
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
        let pos = position(file: file, rank: rank)
        return (ChessFile.get(text: file) | ChessRank.get(text: rank)) & ~pos
    }

    // MARK: Queen
    static func queen(file: String, rank: String) -> UInt64 {
        return bishop(file: file, rank: rank) | rook(file: file, rank: rank)
    }

    // MARK: King
    static func king(file: String, rank: String) -> UInt64 {
        let pos = position(file: file, rank: rank)
        var value = pos

        let notAFile = pos & ChessFile.get(text: "notA") > 0
        let notHFile = pos & ChessFile.get(text: "notH") > 0
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