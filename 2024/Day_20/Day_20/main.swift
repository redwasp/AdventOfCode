//
//  main.swift
//  Day_20
//
//  Created by Pavlo Liashenko on 22.12.2024.
//

import Foundation
import AdventOfCodeStarterPack

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL, encoding: .utf8).trimmingCharacters(in: .whitespacesAndNewlines)
var field = inputFileData.components(separatedBy:.newlines).map{$0.map{$0}}
var start: Position = .zero
var end: Position = .zero
for (y, line) in field.enumerated() {
    for (x, char) in line.enumerated() {
        if char == "S" {
            start = Position(x ,y)
        } else if char == "E" {
            end = Position(x ,y)
        }
    }
}
field[start] = "."
field[end] = "."
var height = field.count
var width = field.first!.count

var from = Array(repeating: Array(repeating: -1, count: width), count: height)

var pos = start
var steps = 0
while pos != end {
    from[pos] = steps
    var next: [Position] = []
    for dir in Directions.clockwise {
        let newPos = pos + dir
        if field[safe: newPos] != "#", from[safe: newPos] == -1  {
            next.append(newPos)
        }
    }
    if next.count != 1 {
        print("Error")
    }
    pos = next.first!
    steps += 1
}
from[end] = steps
var saves : [Int: Int] = [:]

pos = start
var newPos = pos
while pos != end {
    for dir in Directions.clockwise {
        let aPos = pos + dir
        let bPos = aPos + dir
        if field[safe: aPos] == "#",
           field[safe: bPos] == ".",
           let f = from[safe: pos],
           let t = from[safe: bPos],
           t > f {
           let save = t - f - 2
           saves[save, default: 0] += 1
           //print(save, pos, "->", bPos)
        } else if field[safe: aPos] != "#",
                from[aPos] > from[pos] {
                newPos = aPos
        }
    }
    pos = newPos
}
let result = saves.reduce(0) {$0 + ($1.key >= 100 ? $1.value : 0)}
print("Day_20_1:", result)

var walls = Array(repeating: Array(repeating: -1, count: width), count: height)
saves = [:]
pos = start
newPos = pos
var ax = 0
while pos != end {
    for dir in Directions.clockwise {
        let aPos = pos + dir
        if field[safe: aPos] != "#",
            from[aPos] > from[pos] {
            newPos = aPos
        }
    }
    let f = from[pos]
    for y in -20...20 {
        for x in -20...20 {
            if x == 0 && y == 0 {continue}
            let steps = abs(x) + abs(y)
            if steps > 20 {continue}
            let offset = Position(x, y)
            let aPos = pos + offset
            if field[safe: aPos] == ".",
               from[aPos] > (f + steps) {
                let save = from[aPos] - f - steps
                saves[save, default: 0] += 1
            }
        }
    }
    pos = newPos
}

let result2 = saves.reduce(0) {$0 + ($1.key >= 100 ? $1.value : 0)}
print("Day_20_2:", result2)
