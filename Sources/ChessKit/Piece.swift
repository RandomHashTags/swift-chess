
public struct Piece: Sendable {
    public var bitMap:BitMap
    public let owner:ChessPlayer
    public var type:PieceType

    public init(
        position: BitBoard,
        owner: ChessPlayer,
        type: PieceType
    ) {
        self.owner = owner
        self.type = type
        switch type {
        case .pawn:
            bitMap = .init(
                position: position,
                attacking: owner == .black ? .blackPawnAttack(at: position) : .whitePawnAttack(at: position)
            )
        case .bishop:
            bitMap = .init(position: position, attacking: .bishopAttack(at: position))
        case .knight:
            bitMap = .init(position: position, attacking: .knightAttack(at: position))
        case .rook:
            bitMap = .init(position: position, attacking: .rookAttack(at: position))
        case .queen:
            bitMap = .init(position: position, attacking: .queenAttack(at: position))
        case .king:
            bitMap = .init(position: position, attacking: .kingAttack(at: position))
        }
    }
}