//
//  ChessBoard.swift
//
//
//  Created by Evan Anderson on 1/26/25.
//

struct ChessBoard : Sendable {
    /// Horizontal
    let files:Int

    /// Vertical
    let ranks:Int

    init(files: Int = 8, ranks: Int = 8) {
        self.files = files
        self.ranks = ranks
    }

    func display(with positions: [ChessPosition:ChessPiece.Active]) {
        let filesTimes2:Int = files*2
        var string:String = ""
        for _ in 0..<files/2 {
            string += " "
        }
        string += "Black\n"
        for _ in 0..<filesTimes2 {
            string += "-"
        }
        string += "\n"
        for rank in 0..<ranks {
            string += "|"
            for file in 0..<files {
                let position:ChessPosition = ChessPosition(file: file, rank: rank)
                if let active:ChessPiece.Active = positions[position] {
                    string += active.piece == .pawn ? "p" : active.piece.symbol
                } else {
                    string += " "
                }
                string += "|"
            }
            string += "\n"
            /*for _ in 0..<filesTimes2 {
                string += "-"
            }
            string += "\n"*/
        }
        string += "\n"
        for _ in 0..<filesTimes2 {
            string += "-"
        }
        string += "\n"
        for _ in 0..<files/2 {
            string += " "
        }
        string += "White"
        print(string)
    }
}