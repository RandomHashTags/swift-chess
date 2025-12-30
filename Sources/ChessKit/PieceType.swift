
public enum PieceType: Sendable {
    case pawn(isWhite: Bool)

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