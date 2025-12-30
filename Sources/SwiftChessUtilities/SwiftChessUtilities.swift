
// MARK: File
public enum ChessFile {
    case a
    case b
    case c
    case d
    case e
    case f
    case g
    case h

    case notA
    case notB
    case notC
    case notD
    case notE
    case notF
    case notG
    case notH

    package init?<T: BinaryInteger>(_ file: T) {
        switch file {
        case 0: self = .a
        case 1: self = .b
        case 2: self = .c
        case 3: self = .d
        case 4: self = .e
        case 5: self = .f
        case 6: self = .g
        case 7: self = .h
        default: return nil
        }
    }
}

@freestanding(expression)
public macro chessFile(_ file: ChessFile) -> UInt64 = #externalMacro(module: "SwiftChessMacros", type: "ChessFile")

// MARK: Rank
public enum ChessRank {
    case _1
    case _2
    case _3
    case _4
    case _5
    case _6
    case _7
    case _8
}

@freestanding(expression)
public macro chessRank(_ rank: ChessRank) -> UInt64 = #externalMacro(module: "SwiftChessMacros", type: "ChessRank")

// MARK: Attack
@freestanding(expression)
public macro chessAttack(player: ChessPlayer = .white, piece: ChessPiece, file: ChessFile, rank: ChessRank) -> UInt64 = #externalMacro(module: "SwiftChessMacros", type: "ChessAttack")

// MARK: Bit Map
@freestanding(expression)
public macro chessBitMap(_ bitMap: ChessBitMap) -> UInt64 = #externalMacro(module: "SwiftChessMacros", type: "ChessBitMap")