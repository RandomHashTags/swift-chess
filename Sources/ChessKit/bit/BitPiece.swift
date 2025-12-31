
import ChessUtilities

public struct BitPiece: Sendable {
    public internal(set) var position:BitMap
    public internal(set) var attacking:BitMap
    public internal(set) var type:PieceType
    public internal(set) var owner:PlayerColor
    public internal(set) var removed:Bool

    public init(
        position: BitMap,
        type: PieceType,
        owner: PlayerColor
    ) {
        self.position = position
        self.type = type
        self.owner = owner
        removed = false
        attacking = Self.attackingBitMap(for: type, at: position, owner: owner)
    }

    mutating func move(to: BitMap) {
        position = to
        attacking = Self.attackingBitMap(for: type, at: to, owner: owner)
    }

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