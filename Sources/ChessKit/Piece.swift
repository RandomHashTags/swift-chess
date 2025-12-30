
public struct Piece: Sendable {
    public var position:BitMap
    public var attacking:BitMap
    public var removed:Bool

    public init(
        position: BitMap,
        owner: ChessPlayer,
        type: PieceType
    ) {
        self.position = position
        removed = false
        switch type {
        case .pawn:
            attacking = owner == .black ? .blackPawnAttack(at: position) : .whitePawnAttack(at: position)
        case .bishop:
            attacking = .bishopAttack(at: position)
        case .knight:
            attacking = .knightAttack(at: position)
        case .rook:
            attacking = .rookAttack(at: position)
        case .queen:
            attacking = .queenAttack(at: position)
        case .king:
            attacking = .kingAttack(at: position)
        }
    }
}