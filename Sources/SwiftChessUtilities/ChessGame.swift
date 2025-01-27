//
//  ChessGame.swift
//
//
//  Created by Evan Anderson on 1/26/25.
//

public struct ChessGame : Sendable {
    public let clock:ContinuousClock
    public let chessClock:ChessClock?
    public let board:ChessBoard
    public var move:Int = 1

    public var thinkingInstant:ContinuousClock.Instant
    public var player1RemainingThinkDuration:ContinuousClock.Duration
    public var player2RemainingThinkDuration:ContinuousClock.Duration
    public var positions:[ChessPosition:ChessPiece.Active]

    public var log:[LogEntry]

    public let player1:ChessPlayer
    public let player2:ChessPlayer
    /// Which player got to make the first move.
    public let firstMove:ChessPlayer

    /// Who's turn it is to make a move.
    public var thinking:ChessPlayer

    public var inCheck:Bool
    public var inCheckmate:Bool

    public init(
        chessClock: ChessClock?,
        board: ChessBoard = ChessBoard(),
        player1: ChessPlayer = .white,
        player2: ChessPlayer = .black,
        firstMove: ChessPlayer = .white
    ) {
        clock = ContinuousClock()
        self.chessClock = chessClock
        if let chessClock:ChessClock = chessClock {
            player1RemainingThinkDuration = chessClock.duration
            player2RemainingThinkDuration = chessClock.duration
        } else {
            player1RemainingThinkDuration = .zero
            player2RemainingThinkDuration = .zero
        }
        self.board = board
        self.player1 = player1
        self.player2 = player2
        self.firstMove = firstMove
        thinking = firstMove
        thinkingInstant = clock.now
        var pos:[ChessPosition:ChessPiece.Active] = [:]
        for piece in ChessPiece.allCases {
            let positions1:Set<ChessPosition> = player1.startingPositions(for: piece, at: board)
            for position in positions1 {
                pos[position] = ChessPiece.Active(piece: piece, owner: player1, firstMove: true)
            }
            let positions2:Set<ChessPosition> = player2.startingPositions(for: piece, at: board)
            for position in positions2 {
                pos[position] = ChessPiece.Active(piece: piece, owner: player2, firstMove: true)
            }
        }
        positions = pos
        log = []
        inCheck = false
        inCheckmate = false
    }

    @inlinable
    public var thinkingDuration : Duration {
        return thinkingInstant - clock.now
    }

    @inlinable
    public func piece(at position: ChessPosition) -> ChessPiece.Active? {
        return positions[position]
    }

    @inlinable
    public mutating func move(_ move: ChessMove) throws -> ChessMove.Result {
        let thinkDuration:Duration = thinkingDuration
        guard var piece:ChessPiece.Active = piece(at: move.from), piece.owner == thinking, thinking.canMove(piece, move: move, for: self) else {
            throw ChessMoveError.illegal
        }
        let captured:ChessPiece.Active? = positions[move.to]
        positions[move.from] = nil
        piece.firstMove = false
        positions[move.to] = piece
        log.append(LogEntry(thinkDuration: thinkDuration, player: thinking, piece: piece.piece, move: move))
        switch thinking {
        case .black:
            if chessClock != nil {
                player2RemainingThinkDuration -= thinkDuration
                if let increment:ContinuousClock.Duration = chessClock?.increment(self.move) {
                    player2RemainingThinkDuration += increment
                }
            }
            thinking = .white
        case .white:
            if chessClock != nil {
                player1RemainingThinkDuration -= thinkDuration
                if let increment:ContinuousClock.Duration = chessClock?.increment(self.move) {
                    player1RemainingThinkDuration += increment
                }
            }
            thinking = .black
        }
        if thinking == firstMove {
            self.move += 1
        }
        thinkingInstant = clock.now
        calculateCheckStatus()
        return ChessMove.Result(captured: captured, promotion: move.promotion, opponentInCheck: inCheck, opponentWasCheckmated: inCheckmate)
    }

    func display() {
        board.display(with: positions)
    }
}

// MARK: LogEntry
extension ChessGame {
    public struct LogEntry : Sendable {
        public let thinkDuration:Duration
        public let player:ChessPlayer
        public let piece:ChessPiece
        public let move:ChessMove

        public init(thinkDuration: Duration, player: ChessPlayer, piece: ChessPiece, move: ChessMove) {
            self.thinkDuration = thinkDuration
            self.player = player
            self.piece = piece
            self.move = move
        }

        @inlinable
        public var isEnPassantable : Bool {
            return piece == .pawn && (move.distance.ranks == 2 || move.distance.ranks == -2)
        }
    }
}

// MARK: Check status
extension ChessGame {
    @usableFromInline
    mutating func calculateCheckStatus() {
        for (kingPos, piece) in positions {
            if piece.piece == .king && piece.owner == thinking {
                var pos:ChessPosition = kingPos
                sameFile: for i in 1..<board.ranks {
                    pos.rank = kingPos.rank + i
                    if let threat:ChessPiece.Active = positions[pos] {
                        if threat.owner != thinking && (threat.is(.rook) || threat.is(.queen)) {
                            calculateCheckmateStatus(kingPos: kingPos)
                            return
                        } else {
                            break sameFile
                        }
                    }

                    pos.rank = kingPos.rank - i
                    if let threat:ChessPiece.Active = positions[pos] {
                        if threat.owner != thinking && (threat.is(.rook) || threat.is(.queen)) {
                            calculateCheckmateStatus(kingPos: kingPos)
                            return
                        } else {
                            break sameFile
                        }
                    }
                }
                pos = kingPos
                
                var i:Int = 1
                var ignoreRightFile:Bool = false
                var ignoreLeftFile:Bool = false
                var ignoreRightDiagonal:Bool = false
                var ignoreLeftDiagonal:Bool = false
                while i < board.files {
                    if !ignoreRightFile {
                        // check files to the right
                        pos = ChessPosition(file: kingPos.file + i, rank: kingPos.rank)
                        if let threat:ChessPiece.Active = positions[pos] {
                            if threat.owner != thinking && (threat.is(.rook) || threat.is(.queen)) {
                                calculateCheckmateStatus(kingPos: kingPos)
                                return
                            } else {
                                ignoreRightFile = true
                            }
                        }
                    }
                    if !ignoreLeftFile {
                        // check files to the left
                        pos = ChessPosition(file: kingPos.file - i, rank: kingPos.file)
                        if let threat:ChessPiece.Active = positions[pos] {
                            if threat.owner != thinking && (threat.is(.rook) || threat.is(.queen)) {
                                calculateCheckmateStatus(kingPos: kingPos)
                                return
                            } else {
                                ignoreLeftFile = true
                            }
                        }
                    }
                    if !ignoreRightDiagonal {
                        // check diagonal to the right
                        pos = ChessPosition(file: kingPos.file + i, rank: kingPos.rank + i)
                        if let threat:ChessPiece.Active = positions[pos] {
                            if threat.owner != thinking && (threat.is(.bishop) || threat.is(.queen)) {
                                calculateCheckmateStatus(kingPos: kingPos)
                                return
                            } else {
                                ignoreRightDiagonal = true
                            }
                        }

                        pos.rank = kingPos.rank - i
                        if let threat:ChessPiece.Active = positions[pos] {
                            if threat.owner != thinking && (threat.is(.bishop) || threat.is(.queen)) {
                                calculateCheckmateStatus(kingPos: kingPos)
                                return
                            } else {
                                ignoreRightDiagonal = true
                            }
                        }
                    }
                    if !ignoreLeftDiagonal {
                        // check diagonal to the left
                        pos = ChessPosition(file: kingPos.file - i, rank: kingPos.rank + i)
                        if let threat:ChessPiece.Active = positions[pos] {
                            if threat.owner != thinking && (threat.is(.bishop) || threat.is(.queen)) {
                                calculateCheckmateStatus(kingPos: kingPos)
                                return
                            } else {
                                ignoreLeftDiagonal = true
                            }
                        }

                        pos.rank = kingPos.rank - i
                        if let threat:ChessPiece.Active = positions[pos] {
                            if threat.owner != thinking && (threat.is(.bishop) || threat.is(.queen)) {
                                calculateCheckmateStatus(kingPos: kingPos)
                                return
                            } else {
                                ignoreLeftDiagonal = true
                            }
                        }
                    }
                    if i <= 2 {
                        let increment:Int
                        if i == 2 {
                            increment = 1
                        } else {
                            increment = 2
                        }
                        pos = ChessPosition(file: kingPos.file + i, rank: kingPos.rank + increment)
                        if let threat:ChessPiece.Active = positions[pos], threat.owner != thinking && threat.is(.knight) {
                            calculateCheckmateStatus(kingPos: kingPos)
                            return
                        }
                        pos.rank = kingPos.rank - increment
                        if let threat:ChessPiece.Active = positions[pos], threat.owner != thinking && threat.is(.knight) {
                            calculateCheckmateStatus(kingPos: kingPos)
                            return
                        }

                        pos = ChessPosition(file: kingPos.file - i, rank: kingPos.rank + increment)
                        if let threat:ChessPiece.Active = positions[pos], threat.owner != thinking && threat.is(.knight) {
                            calculateCheckmateStatus(kingPos: kingPos)
                            return
                        }
                        pos.rank = kingPos.rank - increment
                        if let threat:ChessPiece.Active = positions[pos], threat.owner != thinking && threat.is(.knight) {
                            calculateCheckmateStatus(kingPos: kingPos)
                            return
                        }
                    }
                    i += 1
                }
                break
            }
        }
        inCheck = false
    }
}

// MARK: Checkmate status
extension ChessGame {
    /// Thinking player is in check; calculate if it is checkmate
    mutating func calculateCheckmateStatus(kingPos: ChessPosition) { // TODO: finish
        inCheck = true
        inCheckmate = false
    }
}