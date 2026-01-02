
/// - Index 0: Pawns
/// - Index 1: Bishops
/// - Index 2: Knights
/// - Index 3: Rooks
/// - Index 4: Queens
/// - Index 5: Kings
/// - Index 6: Junk
public typealias PieceTypeIndex = Int

public enum PieceType: Hashable, Sendable {
    case pawn

    case bishop
    case rook
    case knight

    case queen

    case king
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