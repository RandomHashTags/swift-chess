
import ChessUtilities

public struct BitPiece: Sendable {
    public internal(set) var attacking:BitMap
    public internal(set) var type:PieceType
    public internal(set) var owner:PlayerColor
    public internal(set) var removed:Bool

    public init(
        position: BitMap,
        type: PieceType,
        owner: PlayerColor
    ) {
        self.init(position: position, type: type, owner: owner, removed: false)
    }

    init(
        position: BitMap,
        type: PieceType,
        owner: PlayerColor,
        removed: Bool
    ) {
        self.type = type
        self.owner = owner
        self.removed = removed
        attacking = Self.attackingBitMap(for: type, at: position, owner: owner)
    }

    public var defending: BitMap {
        attacking
    }
}

// MARK: Move
extension BitPiece {
    mutating func move(to: BitMap) {
        attacking = Self.attackingBitMap(for: type, at: to, owner: owner)
    }
}

// MARK: Attack bit map
extension BitPiece {
    static func attackingBitMap(
        for type: PieceType,
        at position: BitMap,
        owner: PlayerColor
    ) -> BitMap {
        switch type {
        case .pawn:
            owner == .white ? .whitePawnAttack(at: position) : .blackPawnAttack(at: position)
        case .bishop:
            .bishopAttack(at: position)
        case .knight:
            .knightAttack(at: position)
        case .rook:
            .rookAttack(at: position)
        case .queen:
            .queenAttack(at: position)
        case .king:
            .kingAttack(at: position)
        }
    }
}