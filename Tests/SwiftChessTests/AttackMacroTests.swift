//
//  AttackMacroTests.swift
//
//
//  Created by Evan Anderson on 1/26/25.
//

#if compiler(>=6.0)

import Testing
@testable import SwiftChessUtilities

struct AttackMacroTests {
    private func binary(_ number : UInt64) -> String {
        let string:String = String(number, radix: 2)
        let padded:String = String(repeating: "0", count: 64 - string.count) + string
        var s:String = ""
        var lastIndex:String.Index = padded.endIndex
        for _ in 0..<8 {
            padded.formIndex(&lastIndex, offsetBy: -8)
            let slice:Substring = padded[lastIndex..<padded.index(lastIndex, offsetBy: 8)]
            s += "\n" + slice
        }
        return "\n" + s.reversed()
    }

    private func attackComment(expected: UInt64, actual: UInt64) -> Comment {
        return Comment(rawValue: "expected=" + binary(expected) + "\nactual=" + binary(actual))
    }

    @Test func pawnAttackMacro() {
        var expected:UInt64 = 327680
        var attacks:UInt64 = #chessAttack(piece: .pawn(.white), file: .b, rank: ._2)
        #expect(attacks == expected, attackComment(expected: expected, actual: attacks))

        expected = 5
        attacks = #chessAttack(piece: .pawn(.black), file: .b, rank: ._2)
        #expect(attacks == expected, attackComment(expected: expected, actual: attacks))
    }

    @Test func knightAttackMacro() {
        ////
        var expected:UInt64 = 1
        var attacks:UInt64 = #chessAttack(piece: .knight, file: .c, rank: ._4)
        #expect(attacks == expected, attackComment(expected: expected, actual: attacks))

        expected = 1
        attacks = #chessAttack(piece: .knight, file: .a, rank: ._1)
        #expect(attacks == expected, attackComment(expected: expected, actual: attacks))
    }

    @Test func bishopAttackMacro() {
        var expected:UInt64 = 4620711952330133792
        var attacks:UInt64 = #chessAttack(piece: .bishop, file: .c, rank: ._4)
        #expect(attacks == expected, attackComment(expected: expected, actual: attacks))

        expected = 9241421688590303744
        attacks = #chessAttack(piece: .bishop, file: .a, rank: ._1)
        #expect(attacks == expected, attackComment(expected: expected, actual: attacks))

        expected = 4620710844295151618
        attacks = #chessAttack(piece: .bishop, file: .a, rank: ._2)
        #expect(attacks == expected, attackComment(expected: expected, actual: attacks))

        expected = 2310355422147510788
        attacks = #chessAttack(piece: .bishop, file: .a, rank: ._3)
        #expect(attacks == expected, attackComment(expected: expected, actual: attacks))

        expected = 567382630219904
        attacks = #chessAttack(piece: .bishop, file: .a, rank: ._8)
        #expect(attacks == expected, attackComment(expected: expected, actual: attacks))

        expected = 72624976668147712
        attacks = #chessAttack(piece: .bishop, file: .h, rank: ._1)
        #expect(attacks == expected, attackComment(expected: expected, actual: attacks))

        expected = 145249953336262720
        attacks = #chessAttack(piece: .bishop, file: .h, rank: ._2)
        #expect(attacks == expected, attackComment(expected: expected, actual: attacks))

        expected = 290499906664153120
        attacks = #chessAttack(piece: .bishop, file: .h, rank: ._3)
        #expect(attacks == expected, attackComment(expected: expected, actual: attacks))

        expected = 18049651735527937
        attacks = #chessAttack(piece: .bishop, file: .h, rank: ._8)
        #expect(attacks == expected, attackComment(expected: expected, actual: attacks))
    }
    
    @Test func rookAttackMacro() {
        var expected:UInt64 = 72340172838076926
        var attacks:UInt64 = #chessAttack(piece: .rook, file: .a, rank: ._1)
        #expect(expected == attacks, attackComment(expected: expected, actual: attacks))

        expected = 144680349887234562
        attacks = #chessAttack(piece: .rook, file: .b, rank: ._4)
        #expect(expected == attacks, attackComment(expected: expected, actual: attacks))
    }

    @Test func queenAttackMacro() {
        var expected:UInt64 = 9313761861428380670
        var attacks:UInt64 = #chessAttack(piece: .queen, file: .a, rank: ._1)
        #expect(expected == attacks, attackComment(expected: expected, actual: attacks))

        expected = 9820426766351346249
        attacks = #chessAttack(piece: .queen, file: .d, rank: ._4)
        #expect(expected == attacks, attackComment(expected: expected, actual: attacks))
    }

    @Test func kingAttackMacro() {
        var expected:UInt64 = 770
        var attacks:UInt64 = #chessAttack(piece: .king, file: .a, rank: ._1)
        #expect(expected == attacks, attackComment(expected: expected, actual: attacks))

        expected = 49216
        attacks = #chessAttack(piece: .king, file: .h, rank: ._1)
        #expect(expected == attacks, attackComment(expected: expected, actual: attacks))

        expected = 120596463616
        attacks = #chessAttack(piece: .king, file: .d, rank: ._4)
        #expect(expected == attacks, attackComment(expected: expected, actual: attacks))
    }
}

#endif