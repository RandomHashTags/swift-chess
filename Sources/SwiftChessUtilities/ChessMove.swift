
public struct ChessMove : CustomStringConvertible, Hashable, Sendable {
    public let from:ChessPosition
    public let to:ChessPosition
    public let promotion:ChessPiece?

    public init(from: ChessPosition, to: ChessPosition, promotion: ChessPiece? = nil) {
        self.from = from
        self.to = to
        self.promotion = promotion
    }
    public init<T: StringProtocol>(from: T, to: T) throws {
        guard let from:ChessPosition = ChessPosition(algebraicNotation: from) else {
            throw ChessMoveError.unrecognized(from)
        }
        guard let to:ChessPosition = ChessPosition(algebraicNotation: to) else {
            throw ChessMoveError.unrecognized(to)
        }
        self.from = from
        self.to = to
        promotion = nil
    }

    @inlinable
    public var description : String {
        return "\(from) -> \(to)"
    }

    @inlinable
    public var distance : (files: Int, ranks: Int) {
        return from.distance(to: to)
    }
}

// MARK: Result
extension ChessMove {
    public struct Result : Sendable {
        public let captured:ChessPiece.Active?
        public let promotion:ChessPiece?
        public let opponentInCheck:Bool
        public let opponentWasCheckmated:Bool

        public init(captured: ChessPiece.Active?, promotion: ChessPiece?, opponentInCheck: Bool, opponentWasCheckmated: Bool) {
            self.captured = captured
            self.promotion = promotion
            self.opponentInCheck = opponentInCheck
            self.opponentWasCheckmated = opponentWasCheckmated
        }
    }
}

// MARK: Annotation
extension ChessMove {
    public enum Annotation : Sendable{
        case blunder
        case check
        case checkmate
        case dubious
        case excellent
        case good
        case interesting
        case mistake

        @inlinable
        public var symbol : String {
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