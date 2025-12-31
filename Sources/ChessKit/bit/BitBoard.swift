
import ChessUtilities

struct BitBoard: Sendable {
    var occupied:BitMap
    var whitePieces:BitMap
    var blackPieces:BitMap

    var pawns:BitMap
    var bishops:BitMap
    var knights:BitMap
    var rooks:BitMap
    var queens:BitMap
    var kings:BitMap

    var bitPieces:[64 of BitPiece]

    public var empty: BitMap {
        ~occupied
    }
}

// MARK: Init
extension BitBoard {
    init() {
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

        var position:BitMap = BitMap.fileA & .rank8
        bitPieces = .init(repeating: .init(position: 0, type: .rook, owner: .white, removed: true))
        bitPieces[position] = .init(position: position, type: .rook, owner: .black)
        bitPieces[position >> 1] = .init(position: position >> 1, type: .knight, owner: .black)
        bitPieces[position >> 2] = .init(position: position >> 2, type: .bishop, owner: .black)
        bitPieces[position >> 3] = .init(position: position >> 3, type: .queen, owner: .black)
        bitPieces[position >> 4] = .init(position: position >> 4, type: .king, owner: .black)
        bitPieces[position >> 5] = .init(position: position >> 5, type: .bishop, owner: .black)
        bitPieces[position >> 6] = .init(position: position >> 6, type: .knight, owner: .black)
        bitPieces[position >> 7] = .init(position: position >> 7, type: .rook, owner: .black)
        bitPieces[position >> 8] = .init(position: position >> 8, type: .pawn, owner: .black)
        bitPieces[position >> 9] = .init(position: position >> 9, type: .pawn, owner: .black)
        bitPieces[position >> 10] = .init(position: position >> 10, type: .pawn, owner: .black)
        bitPieces[position >> 11] = .init(position: position >> 11, type: .pawn, owner: .black)
        bitPieces[position >> 12] = .init(position: position >> 12, type: .pawn, owner: .black)
        bitPieces[position >> 13] = .init(position: position >> 13, type: .pawn, owner: .black)
        bitPieces[position >> 14] = .init(position: position >> 14, type: .pawn, owner: .black)
        bitPieces[position >> 15] = .init(position: position >> 15, type: .pawn, owner: .black)

        position = .fileA & .rank2
        bitPieces[position] = .init(position: position, type: .pawn, owner: .white)
        bitPieces[position >> 1] = .init(position: position >> 1, type: .pawn, owner: .white)
        bitPieces[position >> 2] = .init(position: position >> 2, type: .pawn, owner: .white)
        bitPieces[position >> 3] = .init(position: position >> 3, type: .pawn, owner: .white)
        bitPieces[position >> 4] = .init(position: position >> 4, type: .pawn, owner: .white)
        bitPieces[position >> 5] = .init(position: position >> 5, type: .pawn, owner: .white)
        bitPieces[position >> 6] = .init(position: position >> 6, type: .pawn, owner: .white)
        bitPieces[position >> 7] = .init(position: position >> 7, type: .pawn, owner: .white)
        bitPieces[position >> 8] = .init(position: position >> 8, type: .rook, owner: .white)
        bitPieces[position >> 9] = .init(position: position >> 9, type: .knight, owner: .white)
        bitPieces[position >> 10] = .init(position: position >> 10, type: .bishop, owner: .white)
        bitPieces[position >> 11] = .init(position: position >> 11, type: .king, owner: .white)
        bitPieces[position >> 12] = .init(position: position >> 12, type: .queen, owner: .white)
        bitPieces[position >> 13] = .init(position: position >> 13, type: .bishop, owner: .white)
        bitPieces[position >> 14] = .init(position: position >> 14, type: .knight, owner: .white)
        bitPieces[position >> 15] = .init(position: position >> 15, type: .rook, owner: .white)
    }
}

// MARK: Move
extension BitBoard {
    /// - Warning: Does not check if the move is legal!
    mutating func move(
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
        bitPieces[to].removed = true
        bitPieces[from].move(to: to)
    }
}