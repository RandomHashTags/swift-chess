//
//  ChessPlayer.swift
//
//
//  Created by Evan Anderson on 1/26/25.
//

public enum ChessPlayer : Hashable, Sendable {
    /// Player 1
    case white

    /// Player 2
    case black
}

// MARK: Starting positions
extension ChessPlayer {
    @inlinable
    public func startingPositions(for piece: ChessPiece, at board: ChessBoard) -> Set<ChessPosition> {
        let rank:Int
        let pawnRankAddition:Int
        switch self {
        case .black:
            rank = board.ranks-1
            pawnRankAddition = -1
        case .white:
            rank = 0
            pawnRankAddition = 1
        }
        var positions:Set<ChessPosition>
        switch piece {
        case .pawn:
            positions = []
            for i in 0..<board.files {
                positions.insert(ChessPosition(file: i, rank: rank + pawnRankAddition))
            }
        case .bishop:
            return [
                ChessPosition(file: 2, rank: rank),
                ChessPosition(file: board.files-3, rank: rank)
            ]
        case .rook:
            return [
                ChessPosition(file: 0, rank: rank),
                ChessPosition(file: board.files-1, rank: rank)
            ]
        case .knight:
            return [
                ChessPosition(file: 1, rank: rank),
                ChessPosition(file: board.files-2, rank: rank)
            ]
        case .queen:
            positions = [ChessPosition(file: 3, rank: rank)]
        case .king:
            positions = [ChessPosition(file: 4, rank: rank)]
        }
        return positions
    }
}

// MARK: Can move
extension ChessPlayer {
    @inlinable
    public func canMove(_ piece: ChessPiece.Active, move: ChessMove, for game: ChessGame) -> Bool {
        return canMove(piece, from: move.from, to: move.to, for: game)
    }

    @inlinable
    public func canMove(_ piece: ChessPiece.Active, from: ChessPosition, to: ChessPosition, for game: ChessGame) -> Bool {
        let distance:(files: Int, ranks: Int) = from.distance(to: to)
        var canMove:Bool = canMove(piece: piece.piece, firstMove: piece.firstMove, distance: distance)
        if !canMove {
            switch piece.piece {
            case .pawn(_):
                let isCapture:Bool = distance == (1, 1) || distance == (1, -1) || distance == (-1, 1) || distance == (-1, -1)
                if isCapture {
                    if let capturable:ChessPiece.Active = game.positions[to], capturable.owner != game.thinking {
                        // pawn diagonally captures
                        canMove = true
                    } else if let lastMove:ChessGame.LogEntry = game.log.last, lastMove.isEnPassantable && lastMove.player != game.thinking {
                        // pawn diagonally captures via en passant
                        canMove = true
                    }
                }
                break
            default:
                break
            }
        } else {
            // make sure it can move there legally (no square in the path to get there has a piece or impedes movement)
            canMove = canMoveDirectionally(piece, from: from, distance: distance, game: game)
        }
        return canMove
    }

    @inlinable
    public func canMove(
        piece: ChessPiece,
        firstMove: Bool,
        distance: (files: Int, ranks: Int)
    ) -> Bool {
        switch piece {
        case .pawn:
            if firstMove {
                switch self {
                case .black: return distance.ranks == -2 || distance.ranks == -1
                case .white: return distance.ranks == 2 || distance.ranks == 1
                }
            } else {
                let number:Int
                switch self {
                case .black: number = -1
                case .white: number = 1
                }
                return distance.ranks == number
            }
        case .bishop:
            // diagonal
            return distance.files == distance.ranks || distance.files == -distance.ranks
        case .rook:
            // straight line
            return distance.files == 0 && distance.ranks != 0 || distance.files != 0 && distance.ranks == 0
        case .knight:
            switch distance.files {
            case -2, 2: return distance.ranks == 1 || distance.ranks == -1
            case -1, 1: return distance.ranks == 2 || distance.ranks == -2
            default: return false
            }
        case .queen:
            // diagonal or straight line
            return canMove(piece: .bishop, firstMove: firstMove, distance: distance)
                || canMove(piece: .rook, firstMove: firstMove, distance: distance)
        case .king:
            // 9x9 - 1
            return distance <= (1, 1) && distance >= (-1, -1) && distance != (0, 0)
        }
    }
}

// MARK: Can move directionally
extension ChessPlayer {
    @inlinable
    public func canMoveDirectionally(_ piece: ChessPiece.Active, from: ChessPosition, distance: (files: Int, ranks: Int), game: ChessGame) -> Bool {
        // TODO: make sure moving doesn't cause a check
        switch piece.piece {
        case .pawn:
            return true
        case .bishop:
            return canMoveDiagonally(from: from, distance: distance, game: game)
        case .rook:
            if distance.files != 0 {
               return canMoveHorizontally(from: from, distance: distance, game: game)
            } else {
                return canMoveVertically(from: from, distance: distance, game: game)
            }
        case .knight:
            return true
        case .queen:
            if distance.files == 0 {
                return canMoveVertically(from: from, distance: distance, game: game)
            } else if distance.files == distance.ranks || distance.files == -distance.ranks {
                return canMoveDiagonally(from: from, distance: distance, game: game)
            } else {
                return canMoveHorizontally(from: from, distance: distance, game: game)
            }
        case .king:
            return true
        }
    }
    
    @inlinable
    public func canMoveHorizontally(from: ChessPosition, distance: (files: Int, ranks: Int), game: ChessGame) -> Bool {
        let doesCapture:Bool = doesCapture(from: from, distance: distance, game: game)
        let increment:Int = distance.files > 0 ? -1 : 1
        for i in stride(from: distance.files + (doesCapture ? increment : 0), to: from.file, by: increment) {
            if game.positions[from + (i, 0)] != nil {
                return false
            }
        }
        return true
    }

    @inlinable
    public func canMoveVertically(from: ChessPosition, distance: (files: Int, ranks: Int), game: ChessGame) -> Bool {
        let doesCapture:Bool = doesCapture(from: from, distance: distance, game: game)
        let increment:Int = distance.ranks > 0 ? -1 : 1
        for i in stride(from: distance.ranks + (doesCapture ? increment : 0), to: from.rank, by: increment) {
            if game.positions[from + (0, i)] != nil {
                return false
            }
        }
        return true
    }

    @inlinable
    public func canMoveDiagonally(from: ChessPosition, distance: (files: Int, ranks: Int), game: ChessGame) -> Bool {
        let doesCapture:Bool = doesCapture(from: from, distance: distance, game: game)
        let increment:Int = distance.files > 0 ? 1 : -1
        for i in stride(from: distance.files + (doesCapture ? increment : 0), to: from.file, by: increment) {
            if game.positions[from + (i, i)] != nil {
                return false
            }
        }
        return true
    }

    @inlinable
    public func doesCapture(from: ChessPosition, distance: (files: Int, ranks: Int), game: ChessGame) -> Bool {
        guard let capturable:ChessPiece.Active = game.positions[from + distance] else { return false }
        return capturable.owner != game.thinking
    }
}