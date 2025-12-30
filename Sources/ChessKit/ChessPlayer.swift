
public enum ChessPlayer: Hashable, Sendable {
    /// Player 1
    case white

    /// Player 2
    case black
}

// MARK: Starting positions
extension ChessPlayer {
    public func startingPositions(
        for piece: ChessPiece,
        at board: Board
    ) -> Set<Position> {
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
        switch piece {
        case .pawn:
            var positions = Set<Position>()
            for i in 0..<board.files {
                positions.insert(Position(file: i, rank: rank + pawnRankAddition))
            }
            return positions
        case .bishop:
            return [
                Position(file: 2, rank: rank),
                Position(file: board.files-3, rank: rank)
            ]
        case .rook:
            return [
                Position(file: 0, rank: rank),
                Position(file: board.files-1, rank: rank)
            ]
        case .knight:
            return [
                Position(file: 1, rank: rank),
                Position(file: board.files-2, rank: rank)
            ]
        case .queen:
            return [Position(file: 3, rank: rank)]
        case .king:
            return [Position(file: 4, rank: rank)]
        }
    }
}

// MARK: Can move
extension ChessPlayer {
    public func canMove(
        _ piece: ChessPiece.Active,
        move: ChessMove,
        for game: Game
    ) -> Bool {
        return canMove(piece, from: move.from, to: move.to, for: game)
    }

    public func canMove(
        _ piece: ChessPiece.Active,
        from: Position,
        to: Position,
        for game: Game
    ) -> Bool {
        let distance = from.distance(to: to)
        var canMove = canMove(piece: piece.piece, firstMove: piece.firstMove, distance: distance)
        //print("\(piece.owner) can move \(piece.piece) from \(from) to \(to): \(canMove) (distance=\(distance))")
        if !canMove {
            switch piece.piece {
            case .pawn:
                let isCaptureMotion = distance == (1, 1) || distance == (1, -1) || distance == (-1, 1) || distance == (-1, -1)
                if isCaptureMotion {
                    if let capturable = game.positions[to], capturable.owner != game.thinking {
                        // pawn diagonally captures
                        canMove = true
                    } else if let lastMove:Game.LogEntry = game.log.last, lastMove.isEnPassantable && lastMove.player != game.thinking {
                        // can en passant, but is it allowed?
                        if lastMove.player == .white {
                            canMove = to == lastMove.move.from - (0, 1)
                        } else {
                            canMove = to == lastMove.move.from + (0, 1)
                        }
                    }
                }
            default:
                break
            }
        } else {
            // make sure it can move there legally (no square in the path to get there has a piece or impedes movement)
            canMove = canTravel(piece, from: from, distance: distance, game: game)
        }
        return canMove
    }

    public func canMove(
        piece: ChessPiece,
        firstMove: Bool,
        distance: (files: Int, ranks: Int)
    ) -> Bool {
        switch piece {
        case .pawn:
            guard distance.files == 0 else { return false }
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
            switch distance.files {
            case 0: return distance.ranks == 1 || distance.ranks == -1
            case 1, -1: return distance.ranks >= -1 && distance.ranks <= 1
            default: return false
            }
        }
    }
}

// MARK: Can travel
extension ChessPlayer {
    public func canTravel(
        _ piece: ChessPiece.Active,
        from: Position,
        distance: (files: Int, ranks: Int),
        game: Game
    ) -> Bool {
        // TODO: make sure moving doesn't cause a check
        switch piece.piece {
        case .pawn:
            if distance.files == 0 {
                let range:ClosedRange<Int>
                if distance.ranks < 0 {
                    range = distance.ranks...(-1)
                } else {
                    range = 1...distance.ranks
                }
                for rank in range {
                    if game.positions[from + (0, rank)] != nil {
                        return false
                    }
                }
            }
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
            guard let captured = game.positions[from + distance] else { return true }
            return captured.owner != game.thinking
        case .queen:
            if distance.files == 0 {
                return canMoveVertically(from: from, distance: distance, game: game)
            } else if distance.files == distance.ranks || distance.files == -distance.ranks {
                return canMoveDiagonally(from: from, distance: distance, game: game)
            } else {
                return canMoveHorizontally(from: from, distance: distance, game: game)
            }
        case .king:
            guard let captured = game.positions[from + distance] else { return true }
            return captured.owner != game.thinking
        }
    }
    
    public func canMoveHorizontally(
        from: Position,
        distance: (files: Int, ranks: Int),
        game: Game
    ) -> Bool {
        let doesCapture = doesCapture(from: from, distance: distance, game: game) // TODO: fix
        let increment = distance.files > 0 ? -1 : 1
        for i in stride(from: distance.files + (doesCapture ? increment : 0), to: from.file, by: increment) {
            if game.positions[from + (i, 0)] != nil {
                return false
            }
        }
        return true
    }

    public func canMoveVertically(
        from: Position,
        distance: (files: Int, ranks: Int),
        game: Game
    ) -> Bool {
        let doesCapture = doesCapture(from: from, distance: distance, game: game) // TODO: fix
        let increment = distance.ranks > 0 ? -1 : 1
        for i in stride(from: distance.ranks + (doesCapture ? increment : 0), to: from.rank, by: increment) {
            if game.positions[from + (0, i)] != nil {
                return false
            }
        }
        return true
    }

    public func canMoveDiagonally(
        from: Position,
        distance: (files: Int, ranks: Int),
        game: Game
    ) -> Bool {
        let doesCapture = doesCapture(from: from, distance: distance, game: game) // TODO: fix
        let increment = distance.files > 0 ? 1 : -1
        for i in stride(from: distance.files + (doesCapture ? increment : 0), to: from.file, by: increment) {
            if game.positions[from + (i, i)] != nil {
                return false
            }
        }
        return true
    }

    public func doesCapture(
        from: Position,
        distance: (files: Int, ranks: Int),
        game: Game
    ) -> Bool {
        guard let capturable = game.positions[from + distance] else { return false }
        return capturable.owner != game.thinking
    }
}