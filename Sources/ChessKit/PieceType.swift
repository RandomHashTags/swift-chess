
public enum PieceType: Hashable, Sendable {
    case pawn

    case bishop
    case rook
    case knight

    case queen

    case king
}

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

// MARK: Notation
extension PieceType {
    public func notation(
        for player: PlayerColor,
        type: NotationType
    ) -> String {
        switch type {
        case .forsythEdwards: notationFEN(for: player)
        }
    }
}

// MARK: FEN
extension PieceType {
    public func notationFEN(for player: PlayerColor) -> String {
        switch player {
        case .white:
            switch self {
            case .pawn: "P"
            case .bishop: "B"
            case .rook: "R"
            case .knight: "N"
            case .queen: "Q"
            case .king: "K"
            }
        case .black:
            switch self {
            case .pawn: "p"
            case .bishop: "b"
            case .rook: "r"
            case .knight: "n"
            case .queen: "q"
            case .king: "k"
            }
        }
    }
}