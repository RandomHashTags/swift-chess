
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
            king: .init(position: position >> 4, type: .king),
            pieces: [
                .init(position: position, type: .rook),
                .init(position: position >> 1, type: .knight),
                .init(position: position >> 2, type: .bishop),
                .init(position: position >> 3, type: .queen),
                .init(position: position >> 5, type: .bishop),
                .init(position: position >> 6, type: .knight),
                .init(position: position >> 7, type: .rook),
                .init(position: position >> 8, type: .pawn(isWhite: false)),
                .init(position: position >> 9, type: .pawn(isWhite: false)),
                .init(position: position >> 10, type: .pawn(isWhite: false)),
                .init(position: position >> 11, type: .pawn(isWhite: false)),
                .init(position: position >> 12, type: .pawn(isWhite: false)),
                .init(position: position >> 13, type: .pawn(isWhite: false)),
                .init(position: position >> 14, type: .pawn(isWhite: false)),
                .init(position: position >> 15, type: .pawn(isWhite: false))
            ]
        )
        position = .fileH & .rank1
        let white = Player(
            king: .init(position: position << 3, type: .king),
            pieces: [
                .init(position: position, type: .rook),
                .init(position: position << 1, type: .knight),
                .init(position: position << 2, type: .bishop),
                .init(position: position << 4, type: .queen),
                .init(position: position << 5, type: .bishop),
                .init(position: position << 6, type: .knight),
                .init(position: position << 7, type: .rook),
                .init(position: position << 8, type: .pawn(isWhite: true)),
                .init(position: position << 9, type: .pawn(isWhite: true)),
                .init(position: position << 10, type: .pawn(isWhite: true)),
                .init(position: position << 11, type: .pawn(isWhite: true)),
                .init(position: position << 12, type: .pawn(isWhite: true)),
                .init(position: position << 13, type: .pawn(isWhite: true)),
                .init(position: position << 14, type: .pawn(isWhite: true)),
                .init(position: position << 15, type: .pawn(isWhite: true))
            ]
        )
        self.black = black
        self.white = white
        self.empty = ~black.piecesBitMap & ~white.piecesBitMap
    }
}

// MARK: Move
extension BitBoard {
    mutating func blackMove(from: BitMap, to: BitMap) {
        black.move(from: from, to: to)
        if white.piecesBitMap & to > 0 {
            white.remove(at: to)
        }
    }

    mutating func whiteMove(from: BitMap, to: BitMap) {
        white.move(from: from, to: to)
        if black.piecesBitMap & to > 0 {
            black.remove(at: to)
        }
    }
}