
public enum MoveError: Error, Sendable {
    case illegal(String)
    case pieceNotFoundForPosition(Position)
    case cannotMoveOpponentPiece
    case unrecognized(any StringProtocol & Sendable)
}