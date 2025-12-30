
import ChessUtilities

// MARK: Bishop
extension BitMap {
    static let whitePawnAttacks:[64 of UInt64] = #chessAttack(player: .white, piece: .pawn)
    static let blackPawnAttacks:[64 of UInt64] = #chessAttack(player: .black, piece: .pawn)
    static let bishopAttacks:[64 of UInt64] = #chessAttack(piece: .bishop)
    static let knightAttacks:[64 of UInt64] = #chessAttack(piece: .knight)
    static let rookAttacks:[64 of UInt64] = #chessAttack(piece: .rook)
    static let queenAttacks:[64 of UInt64] = #chessAttack(piece: .queen)
    static let kingAttacks:[64 of UInt64] = #chessAttack(piece: .king)
}

// MARK: Pawn
extension BitMap {
    static func blackPawnAttack(
        at position: BitMap
    ) -> Self {
        blackPawnAttacks[position.trailingZeroBitCount]
    }

    static func whitePawnAttack(
        at position: BitMap
    ) -> Self {
        whitePawnAttacks[position.trailingZeroBitCount]
    }
}

// MARK: Bishop
extension BitMap {
    static func bishopAttack(
        at position: BitMap
    ) -> Self {
        bishopAttacks[position.trailingZeroBitCount]
    }
}

// MARK: Knight
extension BitMap {
    static func knightAttack(
        at position: BitMap
    ) -> Self {
        knightAttacks[position.trailingZeroBitCount]
    }
}

// MARK: Rook
extension BitMap {
    static func rookAttack(
        at position: BitMap
    ) -> Self {
        rookAttacks[position.trailingZeroBitCount]
    }
}

// MARK: Queen
extension BitMap {
    static func queenAttack(
        at position: BitMap
    ) -> Self {
        queenAttacks[position.trailingZeroBitCount]
    }
}

// MARK: King
extension BitMap {
    static func kingAttack(
        at position: BitMap
    ) -> Self {
        kingAttacks[position.trailingZeroBitCount]
    }
}