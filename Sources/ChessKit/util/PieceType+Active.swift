
import ChessUtilities

// MARK: Active
extension PieceType {
    public struct Active: Hashable, Sendable {
        public var piece:PieceType
        public var owner:PlayerColor
        public var firstMove:Bool

        public func `is`(_ piece: PieceType) -> Bool {
            return self.piece == piece
        }
    }
}