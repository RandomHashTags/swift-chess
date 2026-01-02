
import ChessUtilities

// MARK: Bit Map
@freestanding(expression)
public macro chessBitMap(_ bitMap: ChessBitMap) -> UInt64 = #externalMacro(module: "Macros", type: "ChessBitMap")