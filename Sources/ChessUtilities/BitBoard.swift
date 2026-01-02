
public struct BitBoard: Sendable {
    public package(set) var occupied:BitMap
    public package(set) var whitePieces:BitMap
    public package(set) var blackPieces:BitMap

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
        whitePieces: BitMap,
        blackPieces: BitMap,
        pieces: [7 of BitMap]
    ) {
        occupied = whitePieces | blackPieces
        self.whitePieces = whitePieces
        self.blackPieces = blackPieces
        self.pieces = pieces
    }

    public init() {
        let whitePieces = BitMap.rank1 | .rank2
        let blackPieces = BitMap.rank7 | .rank8
        self.whitePieces = whitePieces
        self.blackPieces = blackPieces
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
        from: BitMap,
        to: BitMap,
        pieceTypeIndex: PieceTypeIndex,
        capturedPieceTypeIndex: PieceTypeIndex
    ) {
        let moveMask = from | to
        // toggle move bits
        occupied ^= moveMask

        // handle captures
        occupied ^= (occupied & to) > 0 ? occupied : 0

        // update piece colors
        whitePieces ^= (whitePieces & from) > 0 ? moveMask : 0
        blackPieces ^= (blackPieces & from) > 0 ? moveMask : 0

        // update piece types
        pieces[pieceTypeIndex] ^= moveMask
        pieces[capturedPieceTypeIndex] ^= to
    }
}