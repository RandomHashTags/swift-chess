
/// Each bit represents a single square on a board. The most significant bit is A8 and the least significant bit is H1.
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
}