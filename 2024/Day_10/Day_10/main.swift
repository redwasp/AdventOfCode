//
//  main.swift
//  Day_10
//
//  Created by Pavlo Liashenko on 10.12.2024.
//

import Foundation
import AdventOfCodeStarterPack

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL, encoding: .utf8).trimmingCharacters(in: .whitespacesAndNewlines)
var field = inputFileData.components(separatedBy:.newlines).map{$0.map{Int(String($0))!}}

var result1 = 0
var result2 = 0

for y in field.indices {
    let row = field[y]
    for x in row.indices {
        if field[y][x] == 0 {
            let pos = Position(x, y)
            result1 += score(pos).count
            result2 += score2(pos)
        }
    }
}
print("Day_10_1: \(result1)")
print("Day_10_2: \(result2)")

func score(_ pos: Position, _ value: Int = 0) -> Set<Position> {
    guard value < 9 else {
        return [pos]
    }
    let value = value + 1
    var set: Set<Position> = []
    for dir in Directions.clockwise {
        if (field[safe: pos + dir] == value) {
            set.formUnion(score(pos + dir, value))
        }
    }
    return set
}

func score2(_ pos: Position, _ value: Int = 0) -> Int {
    guard value < 9 else {
        return 1
    }
    let value = value + 1
    var sum = 0
    for dir in Directions.clockwise {
        if (field[safe: pos + dir] == value) {
            sum += score2(pos + dir, value)
        }
    }
    return sum
}
