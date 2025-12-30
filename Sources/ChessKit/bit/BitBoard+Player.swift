
extension BitBoard {
    struct Player: Sendable {
        var king:BitPiece
        var pieces:[15 of BitPiece]

        private(set) var piecesBitMap:BitMap

        init(
            king: BitPiece,
            pieces: [15 of BitPiece]
        ) {
            self.king = king
            self.pieces = pieces
            var bm = king.position
            for i in pieces.indices {
                bm |= pieces[i].position
            }
            piecesBitMap = bm
        }
    }
}

// MARK: Move
extension BitBoard.Player {
    mutating func move(from: BitMap, to: BitMap) {
        for i in pieces.indices {
            if pieces[i].position == from {
                pieces[i].move(to: to)
                piecesBitMap = (piecesBitMap & ~from) | to
                break
            }
        }
    }
}

// MARK: Remove
extension BitBoard.Player {
    mutating func remove(at position: BitMap) {
        piecesBitMap &= ~position
        for i in pieces.indices {
            if pieces[i].position == position {
                pieces[i].removed = true
                break
            }
        }
    }
}