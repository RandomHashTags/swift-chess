
public enum ChessPiece: Hashable, Equatable, Sendable {
    case pawn

    case bishop
    case rook
    case knight

    case queen

    case king

    public var symbol: String {
        switch self {
        case .pawn: return ""
        case .bishop: return "B"
        case .rook: return "R"
        case .knight: return "N"
        case .queen: return "Q"
        case .king: return "K" 
        }
    }
}

// MARK: Active
extension ChessPiece {
    public struct Active: Hashable, Sendable {
        public var piece:ChessPiece
        public var owner:PlayerColor
        public var firstMove:Bool

        public func `is`(_ piece: ChessPiece) -> Bool {
            return self.piece == piece
        }
    }
}