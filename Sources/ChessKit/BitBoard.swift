
struct BitBoard: Sendable {
    var black:Player
    var white:Player

    init() {
        var position:BitMap = BitMap.fileA & .rank8
        black = .init(
            king: .init(position: position >> 4, owner: .black, type: .king),
            pieces: [
                .init(position: position, owner: .black, type: .rook),
                .init(position: position >> 1, owner: .black, type: .knight),
                .init(position: position >> 2, owner: .black, type: .bishop),
                .init(position: position >> 3, owner: .black, type: .queen),
                .init(position: position >> 5, owner: .black, type: .bishop),
                .init(position: position >> 6, owner: .black, type: .knight),
                .init(position: position >> 7, owner: .black, type: .rook),
                .init(position: position >> 8, owner: .black, type: .pawn),
                .init(position: position >> 9, owner: .black, type: .pawn),
                .init(position: position >> 10, owner: .black, type: .pawn),
                .init(position: position >> 11, owner: .black, type: .pawn),
                .init(position: position >> 12, owner: .black, type: .pawn),
                .init(position: position >> 13, owner: .black, type: .pawn),
                .init(position: position >> 14, owner: .black, type: .pawn),
                .init(position: position >> 15, owner: .black, type: .pawn)
            ]
        )
        position = 1
        white = .init(
            king: .init(position: position << 3, owner: .white, type: .king),
            pieces: [
                .init(position: position, owner: .white, type: .rook),
                .init(position: position << 1, owner: .white, type: .knight),
                .init(position: position << 2, owner: .white, type: .bishop),
                .init(position: position << 4, owner: .white, type: .queen),
                .init(position: position << 5, owner: .white, type: .bishop),
                .init(position: position << 6, owner: .white, type: .knight),
                .init(position: position << 7, owner: .white, type: .rook),
                .init(position: position << 8, owner: .white, type: .pawn),
                .init(position: position << 9, owner: .white, type: .pawn),
                .init(position: position << 10, owner: .white, type: .pawn),
                .init(position: position << 11, owner: .white, type: .pawn),
                .init(position: position << 12, owner: .white, type: .pawn),
                .init(position: position << 13, owner: .white, type: .pawn),
                .init(position: position << 14, owner: .white, type: .pawn),
                .init(position: position << 15, owner: .white, type: .pawn)
            ]
        )
    }
}

// MARK: Player
extension BitBoard {
    struct Player: Sendable {
        var king:Piece
        var pieces:[15 of Piece]
    }
}