
public struct BitBoard: Sendable {
    public package(set) var occupied:BitMap
    public package(set) var colorPieces:[2 of BitMap]

    /// - Index 0: Pawns
    /// - Index 1: Bishops
    /// - Index 2: Knights
    /// - Index 3: Rooks
    /// - Index 4: Queens
    /// - Index 5: Kings
    /// - Index 6: Junk
    public package(set) var pieces:[7 of BitMap]

    public var empty: BitMap {
        ~occupied
    }
}

// MARK: Init
extension BitBoard {
    public init(
        colorPieces: [2 of BitMap],
        pieces: [7 of BitMap]
    ) {
        occupied = colorPieces[0] | colorPieces[1]
        self.colorPieces = colorPieces
        self.pieces = pieces
    }

    public init() {
        let whitePieces = BitMap.rank1 | .rank2
        let blackPieces = BitMap.rank7 | .rank8
        colorPieces = [whitePieces, blackPieces]
        occupied = whitePieces | blackPieces

        let rank1Or8 = BitMap.rank1 | .rank8
        var pieces = [7 of BitMap](repeating: 0)
        pieces[0] = .rank2 | .rank7
        pieces[1] = (.fileC & rank1Or8) | (.fileF & rank1Or8)
        pieces[2] = (.fileB & rank1Or8) | (.fileG & rank1Or8)
        pieces[3] = (.fileA & rank1Or8) | (.fileH & rank1Or8)
        pieces[4] = (.fileD & .rank8)   | (.fileE & .rank1)
        pieces[5] = (.fileE & .rank8)   | (.fileD & .rank1)
        self.pieces = pieces
    }
}

// MARK: Move
extension BitBoard {
    /// - Warning: Does not check if the move is legal!
    public mutating func makeMove(
        _ move: Move
    ) {
        let moveMask = move.from | move.to
        // handle captures
        if occupied & move.to > 0 {
            occupied ^= move.from
        } else {
            occupied ^= moveMask
        }

        // update piece colors
        colorPieces[move.colorIndex] ^= moveMask

        // update piece types
        pieces[move.pieceTypeIndex] ^= moveMask
        pieces[move.capturedPieceTypeIndex] ^= move.to
    }
}