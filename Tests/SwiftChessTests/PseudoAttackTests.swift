
import Testing
@testable import ChessUtilities
@testable import ChessKit

struct PseudoAttackTests {
    public let backSlash:BitMap = 0b10000000_01000000_00100000_00010000_00001000_00000100_00000010_00000001
    public let forwardSlash:BitMap = 0b00000001_00000010_00000100_00001000_00010000_00100000_01000000_10000000
}

// MARK: Pawn
extension PseudoAttackTests {
    @Test
    func pseudoAttacksWhitePawn() {
        var square = .fileA & .rank2
        var expected = (.fileA & (.rank3 | .rank4) | .fileB & .rank3)
        var attacks = BitMap.pseudoAttacks(colorIndex: 0, pieceTypeIndex: .pawn, position: square.position)
        #expect(attacks == expected, bitMapComment(expected: expected, actual: attacks))

        square = .fileA & .rank3
        expected = (.fileA & .rank4) | (.fileB & .rank4)
        attacks = .pseudoAttacks(colorIndex: 0, pieceTypeIndex: .pawn, position: square.position)
        #expect(attacks == expected, bitMapComment(expected: expected, actual: attacks))

        square = .fileB & .rank2
        expected = (.fileA & .rank3) | (.fileB & (.rank3 | .rank4)) | (.fileC & .rank3)
        attacks = .pseudoAttacks(colorIndex: 0, pieceTypeIndex: .pawn, position: square.position)
        #expect(attacks == expected, bitMapComment(expected: expected, actual: attacks))

        square = .fileH & .rank2
        expected = (.fileG & .rank3) | (.fileH & (.rank3 | .rank4))
        attacks = .pseudoAttacks(colorIndex: 0, pieceTypeIndex: .pawn, position: square.position)
        #expect(attacks == expected, bitMapComment(expected: expected, actual: attacks))
    }
}

// MARK: Bishop
extension PseudoAttackTests {
    @Test
    func pseudoAttacksBishop() {
        var square = .fileA & .rank8
        var expected = (.fileB & .rank7) | (.fileC & .rank6) | (.fileD & .rank5) | (.fileE & .rank4) | (.fileF & .rank3) | (.fileG & .rank2) | (.fileH & .rank1)
        expected &= ~square
        var attacks = BitMap.pseudoAttacks(colorIndex: 0, pieceTypeIndex: .bishop, position: square.position)
        #expect(attacks == expected, bitMapComment(expected: expected, actual: attacks))

        expected |= square
        square = .fileH & .rank1
        expected &= ~square
        attacks = BitMap.pseudoAttacks(colorIndex: 0, pieceTypeIndex: .bishop, position: square.position)
        #expect(attacks == expected, bitMapComment(expected: expected, actual: attacks))

        square = .fileA & .rank1
        expected = forwardSlash & ~square
        attacks = BitMap.pseudoAttacks(colorIndex: 0, pieceTypeIndex: .bishop, position: square.position)
        #expect(attacks == expected, bitMapComment(expected: expected, actual: attacks))

        square = .fileC & .rank4
        expected = (.fileB & .rank3) | (.fileB & .rank5) | (.fileA & .rank2) | (.fileA & .rank6) | (.fileD & .rank3) | (.fileD & .rank5) | (.fileE & .rank2) | (.fileE & .rank6) | (.fileF & .rank1) | (.fileF & .rank7) | (.fileG & .rank8)
        expected &= ~square
        attacks = BitMap.pseudoAttacks(colorIndex: 0, pieceTypeIndex: .bishop, position: square.position)
        #expect(attacks == expected, bitMapComment(expected: expected, actual: attacks))

        square = .fileD & .rank4
        expected = forwardSlash | backSlash << 1
        expected &= ~square
        attacks = BitMap.pseudoAttacks(colorIndex: 0, pieceTypeIndex: .bishop, position: square.position)
        #expect(attacks == expected, bitMapComment(expected: expected, actual: attacks))
    }
}

// MARK: Knight
extension PseudoAttackTests {
    @Test
    func pseudoAttacksKnight() {
        var square = .fileA & .rank8
        var expected = ~square & ((.fileB & .rank6) | (.fileC & .rank7))
        var attacks = BitMap.pseudoAttacks(colorIndex: 0, pieceTypeIndex: .knight, position: square.position)
        #expect(attacks == expected, bitMapComment(expected: expected, actual: attacks))

        square = .fileC & .rank8
        expected = ~square & ((.fileA & .rank7) | (.fileB & .rank6) | (.fileD & .rank6) | (.fileE & .rank7))
        attacks = BitMap.pseudoAttacks(colorIndex: 0, pieceTypeIndex: .knight, position: square.position)
        #expect(attacks == expected, bitMapComment(expected: expected, actual: attacks))
    }
}

// MARK: Rook
extension PseudoAttackTests {
    @Test
    func pseudoAttacksRook() {
        var square = .fileA & .rank8
        var expected = ~square & (.fileA | .rank8)
        var attacks = BitMap.pseudoAttacks(colorIndex: 0, pieceTypeIndex: .rook, position: square.position)
        #expect(expected == attacks, bitMapComment(expected: expected, actual: attacks))

        square = .fileH & .rank1
        expected = ~square & (.fileH | .rank1)
        attacks = BitMap.pseudoAttacks(colorIndex: 0, pieceTypeIndex: .rook, position: square.position)
        #expect(expected == attacks, bitMapComment(expected: expected, actual: attacks))

        square = .fileC & .rank4
        expected = ~square & (.fileC | .rank4)
        attacks = BitMap.pseudoAttacks(colorIndex: 0, pieceTypeIndex: .rook, position: square.position)
        #expect(expected == attacks, bitMapComment(expected: expected, actual: attacks))
    }
}

// MARK: Queen
extension PseudoAttackTests {
    @Test
    func pseudoAttacksQueen() {
        var square = .fileA & .rank8
        var expected = ~square & (.fileA | .rank8 | backSlash)
        var attacks = BitMap.pseudoAttacks(colorIndex: 0, pieceTypeIndex: .queen, position: square.position)
        #expect(expected == attacks, bitMapComment(expected: expected, actual: attacks))

        square = .fileH & .rank8
        expected = ~square & (.fileH | .rank8 | forwardSlash)
        attacks = BitMap.pseudoAttacks(colorIndex: 0, pieceTypeIndex: .queen, position: square.position)
        #expect(expected == attacks, bitMapComment(expected: expected, actual: attacks))
    }
}

// MARK: King
extension PseudoAttackTests {
    @Test
    func pseudoAttacksKing() {
        var square = .fileA & .rank8
        var expected = ~square & ((.fileA & .rank7) | (.fileB & .rank7) | (.fileB & .rank8))
        var attacks = BitMap.pseudoAttacks(colorIndex: 0, pieceTypeIndex: .king, position: square.position)
        #expect(expected == attacks, bitMapComment(expected: expected, actual: attacks))
    }
}