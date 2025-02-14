//
//  ChessPosition.swift
//
//
//  Created by Evan Anderson on 1/26/25.
//

public struct ChessPosition : CustomStringConvertible, Hashable, Sendable {
    public static func + (position: ChessPosition, value: (Int, Int)) -> ChessPosition {
        return ChessPosition(file: position.file + value.0, rank: position.rank + value.1)
    }
    public static func - (position: ChessPosition, value: (Int, Int)) -> ChessPosition {
        return ChessPosition(file: position.file - value.0, rank: position.rank - value.1)
    }

    /// Horizontal
    public var file:Int

    /// Vertical
    public var rank:Int

    public init(file: Int, rank: Int) {
        self.file = file
        self.rank = rank
    }

    public init?<S: StringProtocol>(algebraicNotation: S) {
        guard algebraicNotation.count == 2,
            let file:UInt8 = algebraicNotation[algebraicNotation.startIndex].lowercased().first?.asciiValue,
            let rank:UInt8 = algebraicNotation[algebraicNotation.index(after: algebraicNotation.startIndex)].lowercased().first?.asciiValue
        else {
            return nil
        }
        self.file = Int(file) - 97
        self.rank = Int(rank) - 49
    }

    @inlinable
    public func distance(to position: ChessPosition) -> (files: Int, ranks: Int) {
        return (position.file - file, position.rank - rank)
    }

    @inlinable
    public var description : String {
        return fileAlgebraicNotation + "\(rank+1)"
    }

    @inlinable
    var fileAlgebraicNotation : String {
        switch file {
        case 0: return "a"
        case 1: return "b"
        case 2: return "c"
        case 3: return "d"
        case 4: return "e"
        case 5: return "f"
        case 6: return "g"
        default: return "h"
        }
    }
}