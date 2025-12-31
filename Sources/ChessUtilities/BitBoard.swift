
public struct BitBoard: Sendable {
    public package(set) var occupied:BitMap
    public package(set) var whitePieces:BitMap
    public package(set) var blackPieces:BitMap

    public package(set) var pawns:BitMap
    public package(set) var bishops:BitMap
    public package(set) var knights:BitMap
    public package(set) var rooks:BitMap
    public package(set) var queens:BitMap
    public package(set) var kings:BitMap

    public var empty: BitMap {
        ~occupied
    }
}

// MARK: Init
extension BitBoard {
    public init(
        whitePieces: BitMap,
        blackPieces: BitMap,
        pawns: BitMap,
        bishops: BitMap,
        knights: BitMap,
        rooks: BitMap,
        queens: BitMap,
        kings: BitMap
    ) {
        occupied = whitePieces | blackPieces
        self.whitePieces = whitePieces
        self.blackPieces = blackPieces
        self.pawns = pawns
        self.bishops = bishops
        self.knights = knights
        self.rooks = rooks
        self.queens = queens
        self.kings = kings
    }

    public init() {
        let whitePieces = BitMap.rank1 | .rank2
        let blackPieces = BitMap.rank7 | .rank8
        self.whitePieces = whitePieces
        self.blackPieces = blackPieces
        occupied = whitePieces | blackPieces

        let rank1Or8 = BitMap.rank1 | .rank8
        pawns   = .rank2 | .rank7
        bishops = (.fileC & rank1Or8) | (.fileF & rank1Or8)
        knights = (.fileB & rank1Or8) | (.fileG & rank1Or8)
        rooks   = (.fileA & rank1Or8) | (.fileH & rank1Or8)
        queens  = (.fileD & .rank8)   | (.fileE & .rank1)
        kings   = (.fileE & .rank8)   | (.fileD & .rank1)
    }
}

// MARK: Move
extension BitBoard {
    /// - Warning: Does not check if the move is legal!
    package mutating func move(
        from: BitMap,
        to: BitMap
    ) {
        let moveMask = from | to
        occupied ^= moveMask
        whitePieces ^= (whitePieces & from) > 0 ? moveMask : 0
        blackPieces ^= (blackPieces & from) > 0 ? moveMask : 0
        pawns   ^= (pawns & from) > 0 ? moveMask : 0
        bishops ^= (bishops & from) > 0 ? moveMask : 0
        knights ^= (knights & from) > 0 ? moveMask : 0
        rooks   ^= (rooks & from) > 0 ? moveMask : 0
        queens  ^= (queens & from) > 0 ? moveMask : 0
        kings   ^= (kings & from) > 0 ? moveMask : 0
    }
}