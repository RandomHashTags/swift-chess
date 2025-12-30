
public struct ChessMove: CustomStringConvertible, Hashable, Sendable {
    public let from:Position
    public let to:Position
    public let promotion:ChessPiece?

    public init(
        from: Position,
        to: Position,
        promotion: ChessPiece? = nil
    ) {
        self.from = from
        self.to = to
        self.promotion = promotion
    }

    public init(
        from: some StringProtocol & Sendable,
        to: some StringProtocol & Sendable
    ) throws {
        guard let from = Position(algebraicNotation: from) else {
            throw MoveError.unrecognized(from)
        }
        guard let to = Position(algebraicNotation: to) else {
            throw MoveError.unrecognized(to)
        }
        self.from = from
        self.to = to
        promotion = nil
    }

    public var description: String {
        return "\(from) -> \(to)"
    }

    public var distance: (files: Int, ranks: Int) {
        return from.distance(to: to)
    }
}

// MARK: Result
extension ChessMove {
    public struct Result: Sendable {
        public let captured:ChessPiece.Active?
        public let promotion:ChessPiece?
        public let opponentInCheck:Bool
        public let opponentWasCheckmated:Bool

        public init(
            captured: ChessPiece.Active?,
            promotion: ChessPiece?,
            opponentInCheck: Bool,
            opponentWasCheckmated: Bool
        ) {
            self.captured = captured
            self.promotion = promotion
            self.opponentInCheck = opponentInCheck
            self.opponentWasCheckmated = opponentWasCheckmated
        }
    }
}

// MARK: Annotation
extension ChessMove {
    public enum Annotation: Sendable{
        case blunder
        case check
        case checkmate
        case dubious
        case excellent
        case good
        case interesting
        case mistake

        public var symbol: String {
            switch self {
            case .blunder: return "??"
            case .check: return "+"
            case .checkmate: return "#"
            case .dubious: return "?!"
            case .excellent: return "!!"
            case .good: return "!"
            case .interesting: return "!?"
            case .mistake: return "?"
            }
        }
    }
}