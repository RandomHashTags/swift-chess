
import ChessUtilities

public enum ChessBitMap {
    case empty
    case newGame
    case universal

    case startingPositions(forPiece: PieceType, forWhite: Bool)
}