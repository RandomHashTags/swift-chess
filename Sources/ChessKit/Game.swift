
public struct Game: Sendable {
    public let clock:ContinuousClock
    public let chessClock:ChessClock?
    public let board:Board
    public var move = 1

    public var thinkingInstant:ContinuousClock.Instant
    public var player1RemainingThinkDuration:ContinuousClock.Duration
    public var player2RemainingThinkDuration:ContinuousClock.Duration
    public var positions:[Position:PieceType.Active]

    public var log:[LogEntry]

    /// Which player got to make the first move.
    public let firstMove:PlayerColor

    /// Who's turn it is to make a move.
    public var thinking:PlayerColor

    var flags:Flags.RawValue

    public init(
        chessClock: ChessClock? = nil,
        board: Board = Board(),
        firstMove: PlayerColor = .white
    ) {
        clock = ContinuousClock()
        self.chessClock = chessClock
        if let chessClock {
            player1RemainingThinkDuration = chessClock.duration
            player2RemainingThinkDuration = chessClock.duration
        } else {
            player1RemainingThinkDuration = .zero
            player2RemainingThinkDuration = .zero
        }
        self.board = board
        self.firstMove = firstMove
        thinking = firstMove
        thinkingInstant = clock.now
        var pos = [Position:PieceType.Active]()
        for piece in [PieceType.pawn, .rook, .knight, .bishop, .queen, .king] {
            let positions1 = PlayerColor.white.startingPositions(for: piece, at: board)
            for position in positions1 {
                pos[position] = PieceType.Active(piece: piece, owner: PlayerColor.white, firstMove: true)
            }
            let positions2 = PlayerColor.black.startingPositions(for: piece, at: board)
            for position in positions2 {
                pos[position] = PieceType.Active(piece: piece, owner: PlayerColor.black, firstMove: true)
            }
        }
        positions = pos
        log = []
        flags = 0
    }

    public mutating func start() {
        guard !isActive else { return }
        setFlag(.active, value: true)
        thinking = firstMove
        thinkingInstant = clock.now
    }
    public mutating func end() {
        guard isActive else { return }
        setFlag(.active, value: false)
    }

    public var thinkingDuration: Duration {
        return thinkingInstant - clock.now
    }

    public func piece(at position: Position) -> PieceType.Active? {
        return positions[position]
    }

    public func display() {
        board.display(with: positions)
    }
}

// MARK: Flags
extension Game {
    enum Flags: UInt8, Sendable {
        case active = 1
        case inCheck = 2
        case inCheckmate = 4
    }

    private func isFlag(_ flag: Flags) -> Bool {
        flags & flag.rawValue > 0
    }
    private mutating func setFlag(_ flag: Flags, value: Bool) {
        if value {
            flags |= flag.rawValue
        } else {
            flags &= ~flag.rawValue
        }
    }

    public var isActive: Bool {
        isFlag(.active)
    }
    public var inCheck: Bool {
        isFlag(.inCheck)
    }
    public var inCheckmate: Bool {
        isFlag(.inCheckmate)
    }
}

// MARK: Move
extension Game {
    public mutating func move(
        _ move: ChessMove
    ) throws(MoveError) -> ChessMove.Result {
        let thinkDuration = thinkingDuration
        guard var piece = piece(at: move.from) else {
            throw .pieceNotFoundForPosition(move.from)
        }
        guard piece.owner == thinking else {
            throw .cannotMoveOpponentPiece
        }
        guard thinking.canMove(piece, move: move, for: self) else {
            throw .illegal("\(piece.piece) cannot move from \(move.from) to \(move.to)")
        }
        let captured = positions[move.to]
        positions[move.from] = nil
        piece.firstMove = false
        positions[move.to] = piece
        log.append(.init(thinkDuration: thinkDuration, player: thinking, piece: piece.piece, move: move))
        switch thinking {
        case .black:
            if let chessClock {
                player2RemainingThinkDuration -= thinkDuration
                if let increment = chessClock.increment(self.move) {
                    player2RemainingThinkDuration += increment
                }
            }
            thinking = .white
        case .white:
            if let chessClock {
                player1RemainingThinkDuration -= thinkDuration
                if let increment = chessClock.increment(self.move) {
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
        return .init(captured: captured, promotion: move.promotion, opponentInCheck: inCheck, opponentWasCheckmated: inCheckmate)
    }
}

// MARK: LogEntry
extension Game {
    public struct LogEntry: Sendable {
        public let thinkDuration:Duration
        public let player:PlayerColor
        public let piece:PieceType
        public let move:ChessMove

        public init(
            thinkDuration: Duration,
            player: PlayerColor,
            piece: PieceType,
            move: ChessMove
        ) {
            self.thinkDuration = thinkDuration
            self.player = player
            self.piece = piece
            self.move = move
        }

        public var isEnPassantable: Bool {
            return piece == .pawn && (player == .white ? move.distance.ranks == 2 : move.distance.ranks == -2)
        }
    }
}

// MARK: Check status
extension Game {
    @usableFromInline
    mutating func calculateCheckStatus() {
        for (kingPos, piece) in positions {
            if piece.piece == .king && piece.owner == thinking {
                var pos = kingPos
                sameFile: for i in 1..<board.ranks {
                    pos.rank = kingPos.rank + i
                    if let threat = positions[pos] {
                        if threat.owner != thinking && (threat.is(.rook) || threat.is(.queen)) {
                            calculateCheckmateStatus(kingPos: kingPos)
                            return
                        } else {
                            break sameFile
                        }
                    }

                    pos.rank = kingPos.rank - i
                    if let threat = positions[pos] {
                        if threat.owner != thinking && (threat.is(.rook) || threat.is(.queen)) {
                            calculateCheckmateStatus(kingPos: kingPos)
                            return
                        } else {
                            break sameFile
                        }
                    }
                }
                pos = kingPos
                
                var i = 1
                var ignoreRightFile = false
                var ignoreLeftFile = false
                var ignoreRightDiagonal = false
                var ignoreLeftDiagonal = false
                while i < board.files {
                    if !ignoreRightFile {
                        // check files to the right
                        pos = Position(file: kingPos.file + i, rank: kingPos.rank)
                        if let threat = positions[pos] {
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
                        pos = Position(file: kingPos.file - i, rank: kingPos.file)
                        if let threat = positions[pos] {
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
                        pos = Position(file: kingPos.file + i, rank: kingPos.rank + i)
                        if let threat = positions[pos] {
                            if threat.owner != thinking && (threat.is(.bishop) || threat.is(.queen)) {
                                calculateCheckmateStatus(kingPos: kingPos)
                                return
                            } else {
                                ignoreRightDiagonal = true
                            }
                        }

                        pos.rank = kingPos.rank - i
                        if let threat = positions[pos] {
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
                        pos = Position(file: kingPos.file - i, rank: kingPos.rank + i)
                        if let threat = positions[pos] {
                            if threat.owner != thinking && (threat.is(.bishop) || threat.is(.queen)) {
                                calculateCheckmateStatus(kingPos: kingPos)
                                return
                            } else {
                                ignoreLeftDiagonal = true
                            }
                        }

                        pos.rank = kingPos.rank - i
                        if let threat = positions[pos] {
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
                        pos = Position(file: kingPos.file + i, rank: kingPos.rank + increment)
                        if let threat = positions[pos], threat.owner != thinking && threat.is(.knight) {
                            calculateCheckmateStatus(kingPos: kingPos)
                            return
                        }
                        pos.rank = kingPos.rank - increment
                        if let threat = positions[pos], threat.owner != thinking && threat.is(.knight) {
                            calculateCheckmateStatus(kingPos: kingPos)
                            return
                        }

                        pos = Position(file: kingPos.file - i, rank: kingPos.rank + increment)
                        if let threat = positions[pos], threat.owner != thinking && threat.is(.knight) {
                            calculateCheckmateStatus(kingPos: kingPos)
                            return
                        }
                        pos.rank = kingPos.rank - increment
                        if let threat = positions[pos], threat.owner != thinking && threat.is(.knight) {
                            calculateCheckmateStatus(kingPos: kingPos)
                            return
                        }
                    }
                    i += 1
                }
                break
            }
        }
        setFlag(.inCheck, value: false)
    }
}

// MARK: Checkmate status
extension Game {
    /// Thinking player is in check; calculate if it is checkmate
    mutating func calculateCheckmateStatus(kingPos: Position) { // TODO: finish
        setFlag(.inCheck, value: true)
        setFlag(.inCheckmate, value: false)
    }
}