
import ChessKit

var game = Game()
game.display()

try ask(
    "Do you want to play as White or Black?",
    options: [
        "w": {
            print("What is your first move?")
        },
        "b": {
            try move(from: Position(file: 4, rank: 1), to: Position(file: 4, rank: 3))
        }
    ]
)

let commandsTask = Task {
    while !Task.isCancelled {
        guard let input = readLine() else { continue }
        let values = input.split(separator: " ")
        if let key = values.first, let cmd = gameCommands[key] {
            try cmd(input)
        } else {
            unknownCommand()
        }
    }
}

let gameCommands:[Substring:(String) throws -> Void] = [
    "display": { _ in
        game.display()
    },
    "move": { input in
        let values = input.split(separator: " ")
        let from:Substring
        let to:Substring
        switch values.count {
        case 2:
            let item = values[1]
            guard item.count == 4 else { throw MoveError.unrecognized(item) }
            from = item[item.startIndex..<item.index(item.startIndex, offsetBy: 2)]
            to = item[item.index(item.startIndex, offsetBy: 2)..<item.endIndex]
        default:
            from = values[1]
            to = values[2]
        }
        let parsedMove = try ChessMove(from: from, to: to)
        try move(parsedMove)
    },
    "resign": { _ in
        print("Resignation received by \(game.thinking); \(game.thinking == .white ? PlayerColor.black : .white) wins!")
        game.end()
        commandsTask.cancel()
    }
]

let unknownCommandMessage = "Unknown command. Allowed commands: \n- " + ["display", "move <from> <to>", "resign"].joined(separator: "\n- ")

try await commandsTask.value

func unknownCommand() {
    print(unknownCommandMessage)
}

func ask(_ input: String, options: [String:() throws -> Void]) throws {
    let string = input + " (" + options.keys.joined(separator: ",") + ")"
    print(string)
    guard let v = readLine() else { return }
    if let logic = options[v] {
        try logic()
    }
}

@MainActor
func move(
    from: Position,
    to: Position
) throws {
    try move(ChessMove(from: from, to: to))
}

@MainActor
func move(_ move: ChessMove) throws {
    do {
        let thinking = game.thinking
        let result = try game.move(move)
        print("\(thinking) move: \(move)")
    } catch {
        print("ERROR: \(error)")
    }
}