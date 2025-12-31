
import ChessUtilities

struct BitBoard: Sendable {
    var empty:BitMap
    var whitePieces:BitMap
    var blackPieces:BitMap

    var pawns:BitMap
    var bishops:BitMap
    var knights:BitMap
    var rooks:BitMap
    var queens:BitMap
    var kings:BitMap

    var pieces:[64 of BitPiece]
}

// MARK: Init
extension BitBoard {
    init() {
        let whitePieces = BitMap.rank1 | .rank2
        let blackPieces = BitMap.rank7 | .rank8
        self.whitePieces = whitePieces
        self.blackPieces = blackPieces
        empty = ~whitePieces & ~blackPieces

        let rank1Or8 = BitMap.rank1 | .rank8
        pawns   = .rank2 | .rank7
        bishops = (.fileC & rank1Or8) | (.fileF & rank1Or8)
        knights = (.fileB & rank1Or8) | (.fileG & rank1Or8)
        rooks   = (.fileA & rank1Or8) | (.fileH & rank1Or8)
        queens  = (.fileD & .rank8)   | (.fileE & .rank1)
        kings   = (.fileE & .rank8)   | (.fileD & .rank1)

        var position:BitMap = BitMap.fileA & .rank8
        pieces = .init(repeating: .init(position: 0, type: .pawn, owner: .white, removed: true))
        pieces[position] = .init(position: position, type: .rook, owner: .black)
        pieces[position >> 1] = .init(position: position >> 1, type: .knight, owner: .black)
        pieces[position >> 2] = .init(position: position >> 2, type: .bishop, owner: .black)
        pieces[position >> 3] = .init(position: position >> 3, type: .queen, owner: .black)
        pieces[position >> 4] = .init(position: position >> 4, type: .king, owner: .black)
        pieces[position >> 5] = .init(position: position >> 5, type: .bishop, owner: .black)
        pieces[position >> 6] = .init(position: position >> 6, type: .knight, owner: .black)
        pieces[position >> 7] = .init(position: position >> 7, type: .rook, owner: .black)
        pieces[position >> 8] = .init(position: position >> 8, type: .pawn, owner: .black)
        pieces[position >> 9] = .init(position: position >> 9, type: .pawn, owner: .black)
        pieces[position >> 10] = .init(position: position >> 10, type: .pawn, owner: .black)
        pieces[position >> 11] = .init(position: position >> 11, type: .pawn, owner: .black)
        pieces[position >> 12] = .init(position: position >> 12, type: .pawn, owner: .black)
        pieces[position >> 13] = .init(position: position >> 13, type: .pawn, owner: .black)
        pieces[position >> 14] = .init(position: position >> 14, type: .pawn, owner: .black)
        pieces[position >> 15] = .init(position: position >> 15, type: .pawn, owner: .black)

        position = .fileA & .rank2
        pieces[position] = .init(position: position, type: .pawn, owner: .white)
        pieces[position >> 1] = .init(position: position >> 1, type: .pawn, owner: .white)
        pieces[position >> 2] = .init(position: position >> 2, type: .pawn, owner: .white)
        pieces[position >> 3] = .init(position: position >> 3, type: .pawn, owner: .white)
        pieces[position >> 4] = .init(position: position >> 4, type: .pawn, owner: .white)
        pieces[position >> 5] = .init(position: position >> 5, type: .pawn, owner: .white)
        pieces[position >> 6] = .init(position: position >> 6, type: .pawn, owner: .white)
        pieces[position >> 7] = .init(position: position >> 7, type: .pawn, owner: .white)
        pieces[position >> 8] = .init(position: position >> 8, type: .rook, owner: .white)
        pieces[position >> 9] = .init(position: position >> 9, type: .knight, owner: .white)
        pieces[position >> 10] = .init(position: position >> 10, type: .bishop, owner: .white)
        pieces[position >> 11] = .init(position: position >> 11, type: .king, owner: .white)
        pieces[position >> 12] = .init(position: position >> 12, type: .queen, owner: .white)
        pieces[position >> 13] = .init(position: position >> 13, type: .bishop, owner: .white)
        pieces[position >> 14] = .init(position: position >> 14, type: .knight, owner: .white)
        pieces[position >> 15] = .init(position: position >> 15, type: .rook, owner: .white)
    }
}

// MARK: Move
extension BitBoard {
    /// - Warning: Does not check if the move is legal!
    mutating func move(
        from: BitMap,
        to: BitMap
    ) {
        pieces[to].removed = true
        pieces[from].move(to: to)
        empty = (empty & ~to) | from
    }
}