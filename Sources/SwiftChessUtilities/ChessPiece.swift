//
//  ChessPiece.swift
//
//
//  Created by Evan Anderson on 1/26/25.
//

public enum ChessPiece : Hashable, Equatable, Sendable {
    case pawn(ChessPlayer)

    case bishop
    case rook
    case knight

    case queen

    case king

    @inlinable
    public var symbol : String {
        switch self {
        case .pawn: return ""
        case .bishop: return "B"
        case .rook: return "R"
        case .knight: return "N"
        case .queen: return "Q"
        case .king: return "K" 
        }
    }

    func movablePositions(
        for player: ChessPlayer,
        at position: ChessPosition,
        board: ChessBoard
    ) -> Set<ChessPosition> {
        var positions:Set<ChessPosition>
        switch self {
        case .pawn:
            positions = []
            let addition:Int
            switch player {
            case .black: addition = -1
            case .white: addition = 1
            }
            positions.insert(ChessPosition(file: position.file, rank: position.rank + addition))
        case .bishop:
            positions = []
            for file in 1..<board.files {
                for rank in 1..<board.ranks {
                    positions.insert(position + (file, rank))
                    positions.insert(position + (file, -rank))
                    positions.insert(position + (-file, rank))
                    positions.insert(position + (-file, -rank))
                }
            }
        case .rook:
            positions = []
            for file in 1..<board.files {
                positions.insert(position + (file,0))
                positions.insert(position + (-file,0))
            }
            for rank in 1..<board.ranks {
                positions.insert(position + (0,rank))
                positions.insert(position + (0,-rank))
            }
        case .knight:
            return [
                position + (2,1),
                position + (2,-1),
                position + (1,2),
                position + (1,-2),
                position + (-2,1),
                position + (-2,-1),
                position + (-1,2),
                position + (-1,-2),
            ]
        case .queen:
            return ChessPiece.rook.movablePositions(for: player, at: position, board: board).union(ChessPiece.bishop.movablePositions(for: player, at: position, board: board))
        case .king:
            positions = [
                position + (1,1),
                position + (1,0),
                position + (1,-1),
                position + (0,1),
                position + (0,-1),
                position + (-1,1),
                position + (-1,0),
                position + (-1,-1)
            ]
        }
        return positions
    }
}

// MARK: Active
extension ChessPiece {
    public struct Active : Hashable, Sendable {
        public var piece:ChessPiece
        public var owner:ChessPlayer
        public var firstMove:Bool

        @inlinable
        public func `is`(_ piece: ChessPiece) -> Bool {
            return self.piece == piece
        }
    }
}