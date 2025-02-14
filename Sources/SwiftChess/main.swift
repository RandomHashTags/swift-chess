//
//  SwiftChess.swift
//
//
//  Created by Evan Anderson on 1/26/26.
//

import Foundation
import SwiftChessUtilities

var game:ChessGame = ChessGame()

game.display()

try ask(
    "Do you want to play as White or Black?",
    options: [
        "w" : {
            print("What is your first move?")
        },
        "b" : {
            try move(from: ChessPosition(file: 0, rank: 7), to: ChessPosition(file: 0, rank: 5))
        }
    ]
)

let gameCommands:[String:(String) throws -> Void] = [
    "display" : { _ in
        game.display()
    },
    "move" : { input in
        let values:[Substring] = input.split(separator: " ")
        let parsedMove:ChessMove = try ChessMove(from: values[1], to: values[2])
        try move(parsedMove)
    },
    "resign" : { _ in
        game.end()
    }
]

while !Task.isCancelled {
    if let input:String = readLine() {
        let values:[Substring] = input.split(separator: " ")
        if let cmd:(String) throws -> Void = gameCommands[String(values[0])] {
            try cmd(input)
        } else {
            print("Unknown command")
        }
    }
}

func ask(_ input: String, options: [String:() throws -> Void]) throws {
    let string:String = input + " (" + options.keys.joined(separator: ",") + ")"
    print(string)
    guard let v:String = readLine() else { return }
    if let logic:() throws -> Void = options[v] {
        try logic()
    }
}

func move(
    from: ChessPosition,
    to: ChessPosition
) throws {
    try move(ChessMove(from: from, to: to))
}

func move(_ move: ChessMove) throws {
    do {
        let thinking:ChessPlayer = game.thinking
        let result:ChessMove.Result = try game.move(move)
        print("\(thinking) move: \(move)")
    } catch {
        print("\(error)")
    }
}