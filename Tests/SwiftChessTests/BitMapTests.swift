//
//  BitMapTests.swift
//
//
//  Created by Evan Anderson on 1/26/25.
//

#if compiler(>=6.0)

import Testing
@testable import SwiftChessUtilities

struct BitMapTests {

    @Test func kingStartingPosition() {
        var expected:UInt64 = 0b00000000000000000000000000000000000000000000000000000000_00010000
        var result:UInt64 = #chessBitMap(.startingPositions(forPiece: .king, forWhite: true))
        #expect(result == expected, bitMapComment(expected: expected, actual: result))

        expected = 0b00010000_000000000000000000000000000000000000000000000000000000000
        result = #chessBitMap(.startingPositions(forPiece: .king, forWhite: false))
    }

    @Test func queenStartingPosition() {
        var expected:UInt64 = 0b00000000000000000000000000000000000000000000000000000000_00001000
        var result:UInt64 = #chessBitMap(.startingPositions(forPiece: .queen, forWhite: true))
        #expect(result == expected, bitMapComment(expected: expected, actual: result))

        expected = 0b00001000_000000000000000000000000000000000000000000000000000000000
        result = #chessBitMap(.startingPositions(forPiece: .queen, forWhite: false))
    }
}

#endif