
import ChessUtilities

// MARK: Attacks
extension BitBoard {
    /// - Warning: `position` must only contain 1 piece.
    func attacks(for position: BitMap) -> BitMap {
        pawns & position > 0 ? blackPieces & position > 0 ? .blackPawnAttacks[position] : .whitePawnAttack(at: position)
            : bishops & position > 0 ? .bishopAttack(at: position)
            : knights & position > 0 ? .knightAttack(at: position)
            : rooks   & position > 0 ? .rookAttack(at: position)
            : queens  & position > 0 ? .queenAttack(at: position)
            : .kingAttack(at: position)
    }
}