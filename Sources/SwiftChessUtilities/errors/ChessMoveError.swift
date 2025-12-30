
public enum ChessMoveError : Error {
    case illegal(String)
    case pieceNotFoundForPosition(ChessPosition)
    case cannotMoveOpponentPiece
    case unrecognized(any StringProtocol)
}