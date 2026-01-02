
import ChessUtilities

public struct Board: Sendable {
    /// Horizontal
    public let files:Int

    /// Vertical
    public let ranks:Int

    public init(
        files: Int = 8,
        ranks: Int = 8
    ) {
        self.files = files
        self.ranks = ranks
    }
}

// MARK: Display
extension Board {
    public func display(with positions: [Position:PieceType.Active]) {
        let filesTimes2 = files*2
        var string = ""
        for _ in 0..<files/2 {
            string += " "
        }
        string += "Black\n"
        for rank in stride(from: ranks-1, through: 0, by: -1) {
            string += "|"
            var slice = ""
            for file in stride(from: files-1, through: 0, by: -1) {
                let position = Position(file: file, rank: rank)
                if let active = positions[position] {
                    slice += active.piece.notationFEN(for: active.owner)
                } else {
                    slice += " "
                }
                slice += "|"
            }
            slice.removeLast()
            string += slice.reversed()
            string += "|\n|"
            for _ in 0..<filesTimes2-1 {
                string += "-"
            }
            string += "|\n"
        }
        for _ in 0..<files/2 {
            string += " "
        }
        string += "White"
        print(string)
    }
}