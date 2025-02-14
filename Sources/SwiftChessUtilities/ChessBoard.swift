//
//  ChessBoard.swift
//
//
//  Created by Evan Anderson on 1/26/25.
//

public struct ChessBoard : Sendable {
    /// Horizontal
    public let files:Int

    /// Vertical
    public let ranks:Int

    public init(files: Int = 8, ranks: Int = 8) {
        self.files = files
        self.ranks = ranks
    }
}

// MARK: Display
extension ChessBoard {
    public func display(with positions: [ChessPosition:ChessPiece.Active]) {
        let filesTimes2:Int = files*2
        var string:String = ""
        for _ in 0..<files/2 {
            string += " "
        }
        string += "Black\n"
        for rank in stride(from: ranks-1, through: 0, by: -1) {
            string += "|"
            var slice:String = ""
            for file in stride(from: files-1, through: 0, by: -1) {
                let position:ChessPosition = ChessPosition(file: file, rank: rank)
                if let active:ChessPiece.Active = positions[position] {
                    slice += active.is(.pawn) ? "p" : active.piece.symbol
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