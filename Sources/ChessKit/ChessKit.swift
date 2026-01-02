
import ChessUtilities

// MARK: Attack
@freestanding(expression)
public macro chessAttack<let count: Int>(
    player: PlayerColor = .white,
    piece: PieceType
) -> [count of UInt64] = #externalMacro(module: "Macros", type: "PositionalAttacks")

// MARK: Bit Map
@freestanding(expression)
public macro chessBitMap(_ bitMap: ChessBitMap) -> UInt64 = #externalMacro(module: "Macros", type: "ChessBitMap")