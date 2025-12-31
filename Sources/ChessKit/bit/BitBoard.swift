
import ChessUtilities

struct BitBoard: Sendable {
    var empty:BitMap
    var black:Player
    var white:Player
}

// MARK: Init
extension BitBoard {
    init() {
        var position:BitMap = BitMap.fileA & .rank8
        let black = Player(
            king: .init(position: position >> 4, type: .king, owner: .black),
            pieces: [
                .init(position: position, type: .rook, owner: .black),
                .init(position: position >> 1, type: .knight, owner: .black),
                .init(position: position >> 2, type: .bishop, owner: .black),
                .init(position: position >> 3, type: .queen, owner: .black),
                .init(position: position >> 5, type: .bishop, owner: .black),
                .init(position: position >> 6, type: .knight, owner: .black),
                .init(position: position >> 7, type: .rook, owner: .black),
                .init(position: position >> 8, type: .pawn, owner: .black),
                .init(position: position >> 9, type: .pawn, owner: .black),
                .init(position: position >> 10, type: .pawn, owner: .black),
                .init(position: position >> 11, type: .pawn, owner: .black),
                .init(position: position >> 12, type: .pawn, owner: .black),
                .init(position: position >> 13, type: .pawn, owner: .black),
                .init(position: position >> 14, type: .pawn, owner: .black),
                .init(position: position >> 15, type: .pawn, owner: .black)
            ]
        )
        position = .fileH & .rank1
        let white = Player(
            king: .init(position: position << 3, type: .king, owner: .white),
            pieces: [
                .init(position: position, type: .rook, owner: .white),
                .init(position: position << 1, type: .knight, owner: .white),
                .init(position: position << 2, type: .bishop, owner: .white),
                .init(position: position << 4, type: .queen, owner: .white),
                .init(position: position << 5, type: .bishop, owner: .white),
                .init(position: position << 6, type: .knight, owner: .white),
                .init(position: position << 7, type: .rook, owner: .white),
                .init(position: position << 8, type: .pawn, owner: .white),
                .init(position: position << 9, type: .pawn, owner: .white),
                .init(position: position << 10, type: .pawn, owner: .white),
                .init(position: position << 11, type: .pawn, owner: .white),
                .init(position: position << 12, type: .pawn, owner: .white),
                .init(position: position << 13, type: .pawn, owner: .white),
                .init(position: position << 14, type: .pawn, owner: .white),
                .init(position: position << 15, type: .pawn, owner: .white)
            ]
        )
        self.black = black
        self.white = white
        self.empty = ~black.piecesBitMap & ~white.piecesBitMap
    }
}

// MARK: Move
extension BitBoard {
    /// - Warning: Does not check if the move is legal!
    mutating func blackMove(
        from: BitMap,
        to: BitMap
    ) {
        black.move(from: from, to: to)
        if white.piecesBitMap & to > 0 {
            // black took a white piece
            white.remove(at: to)
        }
        empty = (empty & ~to) | from
    }

    /// - Warning: Does not check if the move is legal!
    mutating func whiteMove(
        from: BitMap,
        to: BitMap
    ) {
        white.move(from: from, to: to)
        if black.piecesBitMap & to > 0 {
            // white took a black piece
            black.remove(at: to)
        }
        empty = (empty & ~to) | from
    }
}