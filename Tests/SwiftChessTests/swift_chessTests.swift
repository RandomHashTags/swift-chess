
import Testing
@testable import ChessKit

struct SwiftChessTests {
    let game:Game = Game(chessClock: nil, board: Board(), player1: .white, player2: .black, firstMove: .white)

    @Test func positionDistance() {
        var one = Position(file: 4, rank: 0)
        var two = Position(file: 4, rank: 3)
        var distance:(Int, Int) = one.distance(to: two)
        #expect(distance == (0, 3))

        two = Position(file: 5, rank: 1)
        distance = one.distance(to: two)
        #expect(distance == (1, 1))
    }

    @Test func pawnFirstMoves() {
        // white
        var player = PlayerColor.white
        var piece = PieceType.Active(piece: .pawn, owner: .white, firstMove: true)
        var from = Position(file: 0, rank: 1)
        var to = Position(file: 0, rank: 3)
        #expect(player.canMove(piece, from: from, to: to, for: game))

        piece.firstMove = false
        #expect(!player.canMove(piece, from: from, to: to, for: game))

        to = Position(file: 0, rank: 2)
        #expect(player.canMove(piece, from: from, to: to, for: game))

        // black
        player = .black
        piece.owner = .black
        piece.firstMove = true
        from = Position(file: 0, rank: 6)
        to = Position(file: 0, rank: 4)
        #expect(player.canMove(piece, from: from, to: to, for: game))

        piece.firstMove = false
        #expect(!player.canMove(piece, from: from, to: to, for: game))

        to = Position(file: 0, rank: 5)
        #expect(player.canMove(piece, from: from, to: to, for: game))
    }

    @Test func bishopMoves() {
        // white
        var game:Game = game
        var player = PlayerColor.white
        var piece = PieceType.Active(piece: .bishop, owner: .white, firstMove: true)
        var from = Position(file: 2, rank: 0)
        var to = Position(file: 3, rank: 1)
        #expect(!player.canMove(piece, from: from, to: to, for: game))

        game.positions[Position(file: 3, rank: 1)] = nil
        #expect(player.canMove(piece, from: from, to: to, for: game))
    }

    @Test func rookMoves() {
        // white
        var game:Game = game
        var player = PlayerColor.white
        var piece = PieceType.Active(piece: .rook, owner: .white, firstMove: true)
        var from = Position(file: 0, rank: 0)
        var to = Position(file: 0, rank: 3)
        #expect(!player.canMove(piece, from: from, to: to, for: game))

        game.positions[Position(file: 0, rank: 1)] = nil
        #expect(player.canMove(piece, from: from, to: to, for: game))

        game.positions[Position(file: 1, rank: 0)] = nil
        game.positions[Position(file: 1, rank: 1)] = nil
        to = Position(file: 1, rank: 1)
        #expect(!player.canMove(piece, from: from, to: to, for: game))
    }

    @Test func checkStatus() {
        var game:Game = game
        #expect(game.thinking == .white)
        
        game.positions = [:]
        game.positions[Position(file: 3, rank: 3)] = PieceType.Active(piece: .king, owner: .white, firstMove: false)
        game.positions[Position(file: 3, rank: 6)] = PieceType.Active(piece: .rook, owner: .black, firstMove: false)
        game.calculateCheckStatus()

        #expect(game.inCheck)
    }

    /*
    @Test func example() {
        game.display()
    }
    */
}

func binary(_ number: UInt64) -> String {
    let string = String.init(number, radix: 2)
    let padded = String(repeating: "0", count: 64 - string.count) + string
    var s = ""
    var lastIndex = padded.startIndex
    for _ in 0..<8 {
        let slice = padded[lastIndex..<padded.index(lastIndex, offsetBy: 8)]
        s += "\n" + slice
        padded.formIndex(&lastIndex, offsetBy: 8)
    }
    return "\n" + s
}
func bitMapComment(expected: UInt64, actual: UInt64) -> Comment {
    return Comment(rawValue: "expected=" + binary(expected) + "\nactual=" + binary(actual))
}