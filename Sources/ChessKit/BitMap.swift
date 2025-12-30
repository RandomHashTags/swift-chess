
/// Each bit represents a single square on a board. The least significant bit is A8 and the most significant bit is H1.
/// 
/// Bit shifting left moves up the board, while bit shifting right moves down.
public typealias BitMap = UInt64

// MARK: File
extension BitMap {
    public static let fileA:BitMap = fileH << 7
    public static let fileB:BitMap = fileH << 6
    public static let fileC:BitMap = fileH << 5
    public static let fileD:BitMap = fileH << 4
    public static let fileE:BitMap = fileH << 3
    public static let fileF:BitMap = fileH << 2
    public static let fileG:BitMap = fileH << 1
    public static let fileH:BitMap = 0b00000001_00000001_00000001_00000001_00000001_00000001_00000001_00000001
}

// MARK: Rank
extension BitMap {
    public static let rank8:BitMap = rank1 << 56
    public static let rank7:BitMap = rank1 << 48
    public static let rank6:BitMap = rank1 << 40
    public static let rank5:BitMap = rank1 << 32
    public static let rank4:BitMap = rank1 << 24
    public static let rank3:BitMap = rank1 << 16
    public static let rank2:BitMap = rank1 << 8
    public static let rank1:BitMap = 0b00000000000000000000000000000000000000000000000000000000_11111111
}

// MARK: Special
extension BitMap {
    public static let whiteSquares:BitMap = 0b10101010_01010101_10101010_01010101_10101010_01010101_10101010_01010101
    public static let blackSquares:BitMap = ~whiteSquares
    public static let backSlash:BitMap = 0b10000000_01000000_00100000_00010000_00001000_00000100_00000010_00000001
    public static let forwardSlash:BitMap = 0b00000001_00000010_00000100_00001000_00010000_00100000_01000000_10000000

    private static let bishopRightDiagonal:[_ of Int] = [9, 18, 27, 36, 45, 54, 63]
    private static let bishopLeftDiagonal:[_ of Int] = [7, 14, 21, 28, 35, 42, 49]
}

// MARK: Pawn
extension BitMap {
    static func blackPawnAttack(
        at position: BitMap
    ) -> Self {
        return position >> 9 | position >> 7
    }

    static func whitePawnAttack(
        at position: BitMap
    ) -> Self {
        return position << 9 | position << 7
    }
}

// MARK: Bishop
extension BitMap {
    static func bishopAttack(
        at position: BitMap
    ) -> Self {
        // TODO: optimize
        var attacking:BitMap = 0
        /*if position & whiteSquares > 0 {
            for i in stride(from: 0, through: 63, by: 9) {
                let target = backSlash >> i
                if position & target > 0 {
                    attacking = target
                    break
                }
            }
        } else {
            for i in stride(from: 0, through: 63, by: 9) {
                let target = forwardSlash >> i
                if position & target > 0 {
                    attacking = target
                    break
                }
            }
        }
        attacking &= ~position
        return attacking*/

        let posFile:Int8
        if position & fileA > 0 {
            posFile = 0
        } else if position & fileB > 0 {
            posFile = 1
        } else if position & fileC > 0 {
            posFile = 2
        } else if position & fileD > 0 {
            posFile = 3
        } else if position & fileE > 0 {
            posFile = 4
        } else if position & fileF > 0 {
            posFile = 5
        } else if position & fileG > 0 {
            posFile = 6
        } else {
            posFile = 7
        }
        let posRank:Int8
        if position & rank1 > 0 {
            posRank = 0
        } else if position & rank2 > 0 {
            posRank = 1
        } else if position & rank3 > 0 {
            posRank = 2
        } else if position & rank4 > 0 {
            posRank = 3
        } else if position & rank5 > 0 {
            posRank = 4
        } else if position & rank6 > 0 {
            posRank = 5
        } else if position & rank7 > 0 {
            posRank = 6
        } else {
            posRank = 7
        }

        // movement: left
        var freeLeftFiles = Int(posFile)
        var index = 0
        while freeLeftFiles > 0 {
            index += 1
            let newFile = posFile - Int8(index)
            var newRank = posRank + Int8(index)
            if newFile >= 0 && newFile < 8 && newRank < 8 { // up
                attacking |= position << bishopRightDiagonal[index-1]
            }

            newRank = posRank - Int8(index)
            if newFile >= 0 && newFile < 8 && newRank < 8 { // down
                attacking |= position >> bishopLeftDiagonal[index-1]
            }
            freeLeftFiles -= 1
        }

        // movement: right
        var freeRightFiles = 8 - Int(posFile)
        index = 0
        while freeRightFiles > 0 {
            index += 1
            let newFile = posFile + Int8(index)
            var newRank = posRank + Int8(index)
            if newFile >= 0 && newFile < 8 && newRank < 8 { // up
                attacking |= position << bishopLeftDiagonal[index-1]
            }

            newRank = posRank - Int8(index)
            if newFile >= 0 && newFile < 8 && newRank < 8 { // down
                attacking |= position >> bishopRightDiagonal[index-1]
            }
            freeRightFiles -= 1
        }
        return attacking & ~position
    }
}

// MARK: Knight
extension BitMap {
    static func knightAttack(
        at position: BitMap
    ) -> Self {
        var attacking:BitMap = 0
        let notRank1Or2 = position & (rank1 | rank2) == 0
        let notRank7Or8 = position & (rank7 | rank8) == 0
        if position & fileA == 0 { // not `A` file
            let notBFile = position & fileB == 0
            if notRank1Or2 {
                attacking |= position >> 15 // close left down
                if notBFile {
                    attacking |= position >> 6 // far left down
                }
            }
            if notRank7Or8 {
                attacking |= position << 17 // close left up
                if notBFile {
                    attacking |= position << 10 // far left up
                }
            }
        }
        if position & fileH == 0 { // not `H` file
            let notGFile = position & fileG == 0
            if notRank1Or2 { // not rank 1 or 2
                attacking |= position >> 17 // close right down
                if notGFile {
                    attacking |= position >> 10 // far right down
                }
            }
            if notRank7Or8 {
                attacking |= position << 15 // close right up
                if notGFile {
                    attacking |= position << 6 // far right up
                }
            }
        }
        return attacking
    }
}

// MARK: Rook
extension BitMap {
    static func rookAttack(
        at position: BitMap
    ) -> Self {
        var attacking:BitMap
        if position & fileA > 0 {
            attacking = fileA
        } else if position & fileB > 0 {
            attacking = fileB
        } else if position & fileC > 0 {
            attacking = fileC
        } else if position & fileD > 0 {
            attacking = fileD
        } else if position & fileE > 0 {
            attacking = fileE
        } else if position & fileF > 0 {
            attacking = fileF
        } else {
            attacking = fileH
        }
        if position & rank1 > 0 {
            attacking |= rank1
        } else if position & rank2 > 0 {
            attacking |= rank2
        } else if position & rank3 > 0 {
            attacking |= rank3
        } else if position & rank4 > 0 {
            attacking |= rank4
        } else if position & rank5 > 0 {
            attacking |= rank5
        } else if position & rank6 > 0 {
            attacking |= rank6
        } else if position & rank7 > 0 {
            attacking |= rank7
        } else {
            attacking |= rank8
        }
        return attacking & ~position
    }
}

// MARK: Queen
extension BitMap {
    static func queenAttack(
        at position: BitMap
    ) -> Self {
        return rookAttack(at: position) | bishopAttack(at: position)
    }
}

// MARK: King
extension BitMap {
    static func kingAttack(
        at position: BitMap
    ) -> Self {
        var attacking:BitMap = 0
        let notAFile = position & fileA == 0
        let notHFile = position & fileH == 0
        if notHFile {
            attacking |= position >> 1 // middle left
        }
        if notAFile {
            attacking |= position << 1 // middle right
        }
        if position & rank8 == 0 { // up
            if notHFile {
                attacking |= position << 7 // left
            }
            attacking |= position << 8 // middle
            if notAFile {
                attacking |= position << 9 // right
            }
        }
        if position & rank1 == 0 { // down
            if notHFile {
                attacking |= position >> 9 // left
            }
            attacking |= position >> 8 // middle
            if notAFile {
                attacking |= position >> 7 // right
            }
        }
        return attacking & ~position
    }
}