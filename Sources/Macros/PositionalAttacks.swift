
import ChessUtilities
import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxMacros

enum ChessAttack: ExpressionMacro {
    static func expansion(of node: some FreestandingMacroExpansionSyntax, in context: some MacroExpansionContext) throws -> ExprSyntax {
        var piece = "pawn"
        var white = true
        for argument in node.arguments {
            switch argument.label?.text {
            case "player":
                white = argument.expression.as(MemberAccessExprSyntax.self)?.declName.baseName.text == "white"
            case "piece":
                piece = argument.expression.as(MemberAccessExprSyntax.self)?.declName.baseName.text ?? "pawn"
            default:
                break
            }
        }
        var array = [BitMap](repeating: 0, count: 64)
        var index = 0
        var file = 8
        var rank = 1
        while index < 64 {
            array[index] = get(piece: piece, white: white, file: file, rank: rank)
            file -= 1
            if file == 0 {
                file = 8
                rank += 1
            }
            index += 1
        }
        return "\(raw: array)"
    }

    static func position(file: Int, rank: Int) -> BitMap {
        let (f, r) = position(file: file, rank: rank)
        return f & r
    }
    static func position(file: Int, rank: Int) -> (file: BitMap, rank: BitMap) {
        let f:BitMap
        let r:BitMap
        switch file {
        case 1: f = .fileA
        case 2: f = .fileB
        case 3: f = .fileC
        case 4: f = .fileD
        case 5: f = .fileE
        case 6: f = .fileF
        case 7: f = .fileG
        default: f = .fileH
        }
        switch rank {
        case 1: r = .rank1
        case 2: r = .rank2
        case 3: r = .rank3
        case 4: r = .rank4
        case 5: r = .rank5
        case 6: r = .rank6
        case 7: r = .rank7
        default: r = .rank8
        }
        return (f, r)
    }

    static func get(piece: String, white: Bool, file: Int, rank: Int) -> BitMap {
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
    static func pawn(white: Bool, file: Int, rank: Int) -> BitMap {
        let pos:BitMap = position(file: file, rank: rank)
        return white ? pos << 9 | pos << 7 : pos >> 7 | pos >> 9
    }

    // MARK: Knight
    static func knight(file: Int, rank: Int) -> BitMap {
        let pos:BitMap = position(file: file, rank: rank)
        var value = pos
        if file != 1 { // a
            if rank > 2 {
                let closeLeftDown = pos >> 15
                value |= closeLeftDown
                if file != 2 { // b
                    let farLeftDown = pos >> 6
                    value |= farLeftDown
                }
            }
            if rank < 7 {
                let closeLeftUp = pos << 17
                value |= closeLeftUp
                if file != 2 { // b
                    let farLeftUp = pos << 10
                    value |= farLeftUp
                }
            }
        }
        if file != 8 { // h
            if rank > 2 {
                let closeRightDown = pos >> 17
                value |= closeRightDown
                if file != 7 { // g
                    let farRightDown = pos >> 10
                    value |= farRightDown
                }
            }
            if rank < 7 {
                let closeRightUp = pos << 15
                value |= closeRightUp
                if file != 7 { // g
                    let farRightUp = pos << 6
                    value |= farRightUp
                }
            }
        }
        return value & ~pos
    }

    // MARK: Bishop
    static func bishop(
        file: Int,
        rank: Int
    ) -> BitMap {
        let pos:BitMap = position(file: file, rank: rank)
        let posFile = Int8(file-1)
        let posRank = Int8(rank-1)

        let right:[_ of Int] = [9, 18, 27, 36, 45, 54, 63]
        let left:[_ of Int] = [7, 14, 21, 28, 35, 42, 49]

        var value = pos
        // movement: left
        var freeLeftFiles = Int(posFile)
        var index = 0
        while freeLeftFiles > 0 {
            index += 1
            let newFile = posFile - Int8(index)
            var newRank = posRank + Int8(index)
            if newFile >= 0 && newFile < 8 && newRank < 8 { // up
                value |= pos << right[index-1]
            }

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
            let newFile = posFile + Int8(index)
            var newRank = posRank + Int8(index)
            if newFile >= 0 && newFile < 8 && newRank < 8 { // up
                value |= pos << left[index-1]
            }

            newRank = posRank - Int8(index)
            if newFile >= 0 && newFile < 8 && newRank < 8 { // down
                value |= pos >> right[index-1]
            }
            freeRightFiles -= 1
        }
        return value & ~pos
    }

    // MARK: Rook
    static func rook(file: Int, rank: Int) -> BitMap {
        let (f, r) = position(file: file, rank: rank)
        return (f | r) & ~(f & r)
    }

    // MARK: Queen
    static func queen(file: Int, rank: Int) -> BitMap {
        return bishop(file: file, rank: rank) | rook(file: file, rank: rank)
    }

    // MARK: King
    static func king(file: Int, rank: Int) -> BitMap {
        let pos:BitMap = position(file: file, rank: rank)
        var value = pos

        let notAFile = pos & ~.fileA > 0
        let notHFile = pos & ~.fileH > 0
        if notAFile {
            value |= pos << 1 // middle left
        }
        if notHFile {
            value |= pos >> 1 // middle right
        }
        if pos & .rank8 == 0 { // up
            if notAFile {
                value |= pos << 9 // left
            }
            value |= pos << 8 // middle
            if notHFile {
                value |= pos << 7 // right
            }
        }
        if pos & .rank1 == 0 { // down
            if notAFile {
                value |= pos >> 7 // left
            }
            value |= pos >> 8 // middle
            if notHFile {
                value |= pos >> 9 // right
            }
        }
        return value & ~pos
    }
}