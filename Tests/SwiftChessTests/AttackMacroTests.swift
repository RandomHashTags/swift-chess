
import Testing
@testable import ChessUtilities
@testable import ChessKit

struct AttackMacroTests {
    @Test
    func attackBitMapBishop() {
        var position = .fileA & .rank8
        var expected = (.fileB & .rank7) | (.fileC & .rank6) | (.fileD & .rank5) | (.fileE & .rank4) | (.fileF & .rank3) | (.fileG & .rank2) | (.fileH & .rank1)
        expected &= ~position
        var attacks = BitMap.bishopAttack(at: position)
        #expect(attacks == expected, bitMapComment(expected: expected, actual: attacks))

        expected |= position
        position = .fileH & .rank1
        expected &= ~position
        attacks = .bishopAttack(at: position)
        #expect(attacks == expected, bitMapComment(expected: expected, actual: attacks))

        position = .fileA & .rank1
        expected = .forwardSlash & ~position
        attacks = .bishopAttack(at: position)
        #expect(attacks == expected, bitMapComment(expected: expected, actual: attacks))

        position = .fileC & .rank4
        expected = (.fileB & .rank3) | (.fileB & .rank5) | (.fileA & .rank2) | (.fileA & .rank6) | (.fileD & .rank3) | (.fileD & .rank5) | (.fileE & .rank2) | (.fileE & .rank6) | (.fileF & .rank1) | (.fileF & .rank7) | (.fileG & .rank8)
        expected &= ~position
        attacks = .bishopAttack(at: position)
        #expect(attacks == expected, bitMapComment(expected: expected, actual: attacks))

        position = .fileD & .rank4
        expected = .forwardSlash | .backSlash << 1
        expected &= ~position
        attacks = .bishopAttack(at: position)
        #expect(attacks == expected, bitMapComment(expected: expected, actual: attacks))
    }

    @Test
    func attackBitMapKnight() {
        var position = .fileA & .rank8
        var expected = ~position & ((.fileB & .rank6) | (.fileC & .rank7))
        var attacks = BitMap.knightAttack(at: position)
        #expect(attacks == expected, bitMapComment(expected: expected, actual: attacks))

        position = .fileC & .rank8
        expected = ~position & ((.fileA & .rank7) | (.fileB & .rank6) | (.fileD & .rank6) | (.fileE & .rank7))
        attacks = .knightAttack(at: position)
        #expect(attacks == expected, bitMapComment(expected: expected, actual: attacks))
    }

    @Test
    func attackBitMapRook() {
        var position = .fileA & .rank8
        var expected = ~position & (.fileA | .rank8)
        var attacks = BitMap.rookAttack(at: position)
        #expect(expected == attacks, bitMapComment(expected: expected, actual: attacks))

        position = .fileH & .rank1
        expected = ~position & (.fileH | .rank1)
        attacks = .rookAttack(at: position)
        #expect(expected == attacks, bitMapComment(expected: expected, actual: attacks))

        position = .fileC & .rank4
        expected = ~position & (.fileC | .rank4)
        attacks = .rookAttack(at: position)
        #expect(expected == attacks, bitMapComment(expected: expected, actual: attacks))
    }

    @Test
    func attackBitMapQueen() {
        var position = .fileA & .rank8
        var expected = ~position & (.fileA | .rank8 | .backSlash)
        var attacks = BitMap.queenAttack(at: position)
        #expect(expected == attacks, bitMapComment(expected: expected, actual: attacks))

        position = .fileH & .rank8
        expected = ~position & (.fileH | .rank8 | .forwardSlash)
        attacks = .queenAttack(at: position)
        #expect(expected == attacks, bitMapComment(expected: expected, actual: attacks))
    }

    @Test
    func attackBitMapKing() {
        var position = .fileA & .rank8
        var expected = ~position & ((.fileA & .rank7) | (.fileB & .rank7) | (.fileB & .rank8))
        var attacks = BitMap.kingAttack(at: position)
        #expect(expected == attacks, bitMapComment(expected: expected, actual: attacks))
    }
}