
extension UInt64 {
    public static let fileA:UInt64 = fileH << 7
    public static let fileB:UInt64 = fileH << 6
    public static let fileC:UInt64 = fileH << 5
    public static let fileD:UInt64 = fileH << 4
    public static let fileE:UInt64 = fileH << 3
    public static let fileF:UInt64 = fileH << 2
    public static let fileG:UInt64 = fileH << 1
    public static let fileH:UInt64 = 0b00000001_00000001_00000001_00000001_00000001_00000001_00000001_00000001
}

// MARK: Rank
extension UInt64 {
    public static let rank8:UInt64 = rank1 << 56
    public static let rank7:UInt64 = rank1 << 48
    public static let rank6:UInt64 = rank1 << 40
    public static let rank5:UInt64 = rank1 << 32
    public static let rank4:UInt64 = rank1 << 24
    public static let rank3:UInt64 = rank1 << 16
    public static let rank2:UInt64 = rank1 << 8
    public static let rank1:UInt64 = 0b00000000000000000000000000000000000000000000000000000000_11111111
}
