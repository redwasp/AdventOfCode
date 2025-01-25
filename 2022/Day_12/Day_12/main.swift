//
//  main.swift
//  Day_12
//
//  Created by Pavlo Liashenko on 16.12.2022.
//

import Foundation
import AdventOfCodeStarterPack

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL).trimmingCharacters(in: .whitespacesAndNewlines)
var gridStr = inputFileData.components(separatedBy:.newlines).map{$0.map{$0}}
var width = gridStr[0].count
var height = gridStr.count
var rect = Rect(.zero, Position(width-1, height-1))
var start: Position = .zero
var end: Position = .zero

for y in 0..<height {
    for x in 0..<width {
        let pos = Position(x, y)
        switch gridStr[pos] {
        case "S":
            gridStr[pos] = "a"
            start = pos
        case "E":
            gridStr[pos] = "z"
            end = pos
        default:
            break
        }
    }
}

let alpabet = "abcdefghijklmnopqrstuvwxyz"
    .map{$0}
    .enumerated()
    .reduce(into: [Character: Int]()) {
        $0[$1.element] = $1.offset
    }

var grid = gridStr.map {
    $0.map {
        alpabet[$0]!
    }
}

func steps(from: Position, endWhen: (Position) -> Bool, distance: (Position, Position) -> Int) -> Int {
    var map : [[Int]] = Array(repeating: Array(repeating: 0, count: width), count: height)
    map[from] = 1
    var positions = [from]
    var step = 0
    while positions.count != 0 {
        step += 1
        var nextPositions : [Position] = []
        for position in positions {
            for offset in Directions.clockwise {
                let next = position + offset
                guard rect.contains(next) else {continue}
                guard map[next] == 0 else {continue}
                guard distance(next, position) < 2 else {continue}
                map[next] = step
                if endWhen(next) {
                    return step
                }
                nextPositions.append(next)
            }
        }
        positions = nextPositions
    }
    return 0
}

let steps1 = steps(from: start,
                endWhen: {$0 == end},
               distance: {grid[$0] - grid[$1]})

print("Day12_1: \(steps1)")//462


let steps2 = steps(from: end,
                endWhen: {grid[$0] == 0},
               distance: {grid[$1] - grid[$0]})
print("Day12_2: \(steps2)")//451
