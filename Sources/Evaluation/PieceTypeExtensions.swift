
import ChessKit
import ChessUtilities

extension PieceType {
    public var score: Float {
        switch self {
        case .pawn: 1
        case .bishop: 3
        case .knight: 3
        case .rook: 5
        case .queen: 9
        case .king: 4
        }
    }
}