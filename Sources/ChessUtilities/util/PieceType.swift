
/// - Index 0: Pawns
/// - Index 1: Bishops
/// - Index 2: Knights
/// - Index 3: Rooks
/// - Index 4: Queens
/// - Index 5: Kings
/// - Index 6: Junk
public typealias PieceTypeIndex = Int

extension PieceTypeIndex {
    @inline(__always) public static var pawn:   Self { 0 }
    @inline(__always) public static var bishop: Self { 1 }
    @inline(__always) public static var knight: Self { 2 }
    @inline(__always) public static var rook:   Self { 3 }
    @inline(__always) public static var queen:  Self { 4 }
    @inline(__always) public static var king:   Self { 5 }
    @inline(__always) public static var junk:   Self { 6 }
}

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