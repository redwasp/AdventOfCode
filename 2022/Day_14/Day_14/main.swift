//
//  main.swift
//  Day_14
//
//  Created by Pavlo Liashenko on 17.12.2022.
//

import Foundation
import AdventOfCodeStarterPack

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL).trimmingCharacters(in: .whitespacesAndNewlines)
var rocks = inputFileData
            .components(separatedBy:.newlines)
            .map{$0.components(separatedBy: "->")
            .map{Position($0)!}}

var maxY = rocks.map{$0.map{$0.y}.max()!}.max()! + 2

var cave = Array(repeating: Array(repeating: 0, count: 1000), count: maxY+1)

for rock in rocks {
    for i in 0..<rock.count-1 {
        let from = rock[i]
        let to   = rock[i+1]
        var d = to - from
        d.x = d.x != 0 ? (d.x > 0 ? 1 : -1) : 0
        d.y = d.y != 0 ? (d.y > 0 ? 1 : -1) : 0
        var point = from
        while point != to {
            cave[point] = 1
            point += d
        }
        cave[point] = 1
    }
}

var startCave = cave

var count = 0
var directions : Directions = [.down, .downLeft, .downRight]
main: while true {
    var point = Position(500, 0)
    var continues = true
    while continues {
        continues = false
        for offset in directions {
            let testPoint =  point + offset
            if cave[testPoint] == 0 {
                point = testPoint
                continues = true
                break
            }
        }
        if point.y == maxY {
            break main
        }
    }
    count += 1
    cave[point] = 2
}
print("Day14_1: \(count)")//843

cave = startCave

for i in 0..<1000 {
    cave[maxY][i] = 1
}

var exit = false
count = 0
var point: Position = .one
while point.y != 0 {
    point = Position(500, 0)
    var continues = true
    while continues {
        continues = false
        for offset in directions {
            let testPoint =  point + offset
            if cave[testPoint] == 0 {
                point = testPoint
                continues = true
                break
            }
        }
    }
    count += 1
    cave[point] = 2
}
print("Day14_2: \(count)")//27625
