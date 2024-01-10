//
//  main.swift
//  Day_6
//
//  Created by Pavlo Liashenko on 18.05.2022.
//

import Foundation

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL)
let lines = inputFileData.split(separator: "\n", omittingEmptySubsequences: true)

enum Command : String {
    case TurnOn = "turn on"
    case TurnOff = "turn off"
    case Toggle = "toggle"
}

struct Rect {
    var x, y : Int
    var x1, y1 : Int
    
    init(x: Int, y: Int, x1: Int, y1: Int) {
        self.x = x
        self.y = y
        self.x1 = x1
        self.y1 = y1
    }
}

struct Instruction {
    let command : Command
    let rect : Rect
}

var instructions : [Instruction] = lines.map { line in
    var index = line.index(before:line.firstIndex{$0.isNumber}!)
    let commandValue = String(line[..<index])
    let command = Command(rawValue: commandValue)!
    index = line.index(after: index)
    let substring = line[index...]
    let components = substring.components(separatedBy:" through ")
    let points = components.map {
        $0.components(separatedBy:",").map {
            Int($0)!
        }
    }
    let rect = Rect(x: points[0][0], y: points[0][1], x1: points[1][0], y1: points[1][1])
    return Instruction(command: command, rect: rect)
}

///Optimise this

var grid : [[Bool]] = Array(repeating: Array(repeating: false, count: 1000), count: 1000)

for instruction in instructions {
    let rect = instruction.rect
    let command = instruction.command
    for x in rect.x...rect.x1 {
        for y in rect.y...rect.y1 {
            switch command {
            case .TurnOn:
                grid[y][x] = true
            case .TurnOff:
                grid[y][x] = false
            case .Toggle:
                grid[y][x] = !grid[y][x]
            }
        }
    }
}

let count = grid.reduce(into: 0) { $0 += $1.reduce(into: 0, {$0 += $1 ? 1 : 0})}
print("Day_6_1: \(count)")

var grid2 : [[Int]] = Array(repeating: Array(repeating: 0, count: 1000), count: 1000)

for instruction in instructions {
    let rect = instruction.rect
    let command = instruction.command
    for x in rect.x...rect.x1 {
        for y in rect.y...rect.y1 {
            switch command {
            case .TurnOn:
                grid2[y][x] += 1
            case .TurnOff:
                if grid2[y][x] > 0 {
                    grid2[y][x] -= 1
                }
            case .Toggle:
                grid2[y][x] += 2
            }
        }
    }
}
let count2 = grid2.reduce(into: 0) { $0 += $1.reduce(0, +)}
print("Day_6_2: \(count2)")
