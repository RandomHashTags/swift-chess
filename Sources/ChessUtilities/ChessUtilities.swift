
@freestanding(expression)
public macro pseudoAttacks(
    for piece: PieceType,
    with player: PlayerColor = .white,
) -> [64 of UInt64] = #externalMacro(module: "Macros", type: "PositionalAttacks")