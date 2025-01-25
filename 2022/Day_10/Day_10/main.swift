//
//  main.swift
//  Day_10
//
//  Created by Pavlo Liashenko on 13.12.2022.
//

import Foundation

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL).trimmingCharacters(in: .whitespacesAndNewlines)
var commands = inputFileData.components(separatedBy:"\n").map{Command($0)}

struct Command {
    enum Kind: String {
        case addx = "addx"
        case noop = "noop"
    }
    let kind: Kind
    var argument: Int? = nil
    init(_ command: String) {
        var parts = command.components(separatedBy:.whitespaces)
        self.kind = Kind(rawValue: parts.removeFirst())!
        if parts.count > 0 {
            self.argument = Int(parts[0])
        }
    }
}

var circle = 1
var x = 1
var sum = 0
for command in commands {
    switch command.kind {
    case .addx:
        circle += 2
        if circle % 40 == 21 {
            sum += x*(circle-1)
        }
        x += command.argument!
    case .noop:
        circle += 1
    }
    if circle % 40 == 20 {
        sum += x*circle
    }
}

print("Day_10_1: \(sum)")//12880

let width = 40
let height = 6
var grid = Array(repeating: Array(repeating: false, count: width), count: height)
var sprite = 0
func inSprite(_ pos: Int) -> Bool {
    let x = pos%40
    return x >= sprite && x < sprite + 3
}

func draw(_ pos: Int) {
    //if pos >= 240 {return}
    let x = pos%40
    let y = pos/40
    grid[y][x] = inSprite(pos)
}
circle = 0
for command in commands {
    switch command.kind {
    case .addx:
        draw(circle)
        circle += 1
        draw(circle)
        sprite += command.argument!
    case .noop:
        draw(circle)
    }
    circle += 1

}

let str = grid.reduce(into: "") { $0 += $1.reduce(into:"", { $0 += $1 ? "#" : " "}) + "\n"}

print("Day_10_2:\n\(str)")//FCJAPJRE
