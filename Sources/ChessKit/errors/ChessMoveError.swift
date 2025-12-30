
public enum ChessMoveError: Error {
    case illegal(String)
    case pieceNotFoundForPosition(Position)
    case cannotMoveOpponentPiece
    case unrecognized(any StringProtocol)
}