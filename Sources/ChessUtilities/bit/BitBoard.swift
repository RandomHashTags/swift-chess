
public struct BitBoard: Sendable {
    public package(set) var occupied:BitMap

    /// - Index 0: White
    /// - Index 1: Black
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

// MARK: Display
extension BitBoard {
    public func display() {
        let fenNotations:[2 of [6 of String]] = [
            [
                PieceType.pawn.notationFEN(for: .white),
                PieceType.bishop.notationFEN(for: .white),
                PieceType.knight.notationFEN(for: .white),
                PieceType.rook.notationFEN(for: .white),
                PieceType.queen.notationFEN(for: .white),
                PieceType.king.notationFEN(for: .white)
            ],
            [
                PieceType.pawn.notationFEN(for: .black),
                PieceType.bishop.notationFEN(for: .black),
                PieceType.knight.notationFEN(for: .black),
                PieceType.rook.notationFEN(for: .black),
                PieceType.queen.notationFEN(for: .black),
                PieceType.king.notationFEN(for: .black)
            ]
        ]
        var pieceNotations = [64 of Character](repeating: "-")
        for file in 0..<8 {
            for rank in 0..<8 {
                let index = file + rank*8
                let position:BitMap = 1 << BitMap(index)
                if occupied & position > 0 {
                    let colorIndex:Int
                    if colorPieces[0] & position > 0 {
                        colorIndex = 0
                    } else {
                        colorIndex = 1
                    }
                    var pieceType = 0
                    for i in 0..<pieces.count {
                        if pieces[i] & position > 0 {
                            pieceType = i
                            break
                        }
                    }
                    pieceNotations[index] = fenNotations[colorIndex][pieceType].first!
                }
            }
        }
        var s = ""
        s.reserveCapacity(72)
        for i in pieceNotations.indices {
            if i != 0 && i % 8 == 0 {
                s.append("\n")
            }
            let value = pieceNotations[i]
            s.append(value)
        }
        print(String(s.reversed()))
    }
}