//
//  ChessPosition.swift
//
//
//  Created by Evan Anderson on 1/26/25.
//

struct ChessPosition : Hashable, Sendable {
    static func + (position: ChessPosition, value: (Int, Int)) -> ChessPosition {
        return ChessPosition(file: position.file + value.0, rank: position.rank + value.1)
    }
    static func - (position: ChessPosition, value: (Int, Int)) -> ChessPosition {
        return ChessPosition(file: position.file - value.0, rank: position.rank - value.1)
    }

    /// Horizontal
    var file:Int

    /// Vertical
    var rank:Int

    init(file: Int, rank: Int) {
        self.file = file
        self.rank = rank
    }

    init?<S: StringProtocol>(_ algebraicNotation: S) {
        guard algebraicNotation.count == 2,
            let file:UInt8 = algebraicNotation[algebraicNotation.startIndex].asciiValue,
            let rank:UInt8 = algebraicNotation[algebraicNotation.index(after: algebraicNotation.startIndex)].asciiValue
        else {
            return nil
        }
        self.file = Int(file) - 65
        self.rank = Int(rank) - 48
    }

    func distance(to position: ChessPosition) -> (files: Int, ranks: Int) {
        return (position.file - file, position.rank - rank)
    }
}