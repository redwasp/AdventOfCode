//
//  main.swift
//  Day_8
//
//  Created by Pavlo Liashenko on 03.08.2022.
//

import Foundation

infix operator %%

extension Int {

    static  func %% (_ left: Int, _ right: Int) -> Int { //mod
       let mod = left % right
       return mod >= 0 ? mod : mod + right
    }

}

enum Command {
    case turnOn(width: Int, height: Int)
    case shiftRow(_ row: Int, offset: Int)
    case shiftColumn(_ column: Int, offset: Int)
    
    init?(_ string: String) {
        if string.hasPrefix("rect") {
            let args = string.components(separatedBy:.whitespaces)[1].components(separatedBy:"x").map{Int($0)!}
            self = Command.turnOn(width: args[0], height:args[1])
        } else if string.hasPrefix("rotate row") {
            let args = string.components(separatedBy:"=")[1].components(separatedBy:" by ").map{Int($0)!}
            self = Command.shiftRow(args[0], offset:args[1])
        } else if string.hasPrefix("rotate column") {
            let args = string.components(separatedBy:"=")[1].components(separatedBy:" by ").map{Int($0)!}
            self = Command.shiftColumn(args[0], offset:args[1])
        } else {
            return nil
        }
    }
}

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL)
var lines = inputFileData.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines)
var commands = lines.map{Command($0)!}
let width  = 50
let height = 6

var field : [[Bool]] = Array(repeating: Array(repeating: false, count: width), count: height)

for command in commands {
    switch command {
    case .turnOn(let width, let height):
        for row in 0..<height {
            for column in 0..<width {
                field[row][column] = true
            }
        }
    case .shiftRow(let row, let offset):
        let line = field[row]
        for x in 0..<width {
            let nx = (x + offset) %% width
            field[row][nx] = line[x]
        }
    case .shiftColumn(let column, let offset):
        let line = field.map{$0[column]}
        for y in 0..<height {
            let ny = (y + offset) %% height
            field[ny][column] = line[y]
        }
    }
}

let count = field.reduce(into: 0) { $0 += $1.reduce(into: 0, { $0 += $1 ? 1 : 0})}
print("Day8_1: \(count)")

print("Day8_3:");
var line = ""
for row in field {
    for item in row {
        line += item ? "█" : " "
    }
    line += "\r"
}
print("\(line)")//RURUCEOEIL
