
public struct Move: Sendable {
    public let from:BitMap
    public let to:BitMap
    public let colorIndex:Int
    public let pieceTypeIndex:PieceTypeIndex
    public let capturedPieceTypeIndex:PieceTypeIndex
}