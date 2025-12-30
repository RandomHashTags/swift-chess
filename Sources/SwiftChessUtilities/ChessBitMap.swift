
public enum ChessBitMap {
    case empty
    case newGame
    case universal

    case startingPositions(forPiece: ChessPiece, forWhite: Bool)
}