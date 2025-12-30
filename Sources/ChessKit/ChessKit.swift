
// MARK: Attack
@freestanding(expression)
public macro chessAttack(
    player: PlayerColor = .white,
    piece: ChessPiece
) -> [64 of UInt64] = #externalMacro(module: "Macros", type: "ChessAttack")

// MARK: Bit Map
@freestanding(expression)
public macro chessBitMap(_ bitMap: ChessBitMap) -> UInt64 = #externalMacro(module: "Macros", type: "ChessBitMap")