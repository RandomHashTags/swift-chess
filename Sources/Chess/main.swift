
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

let gameCommands:[String:(String) throws -> Void] = [
    "display": { _ in
        game.display()
    },
    "move": { input in
        let values = input.split(separator: " ")
        let parsedMove = try ChessMove(from: values[1], to: values[2])
        try move(parsedMove)
    },
    "resign": { _ in
        game.end()
    }
]

let unknownCommandMessage = "Unknown command. Allowed commands: \n- " + ["display", "move <from> <to>", "resign"].joined(separator: "\n- ")

while !Task.isCancelled {
    if let input = readLine() {
        let values = input.split(separator: " ")
        if let key = values.first, let cmd = gameCommands[String(key)] {
            try cmd(input)
        } else {
            unknownCommand()
        }
    }
}

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