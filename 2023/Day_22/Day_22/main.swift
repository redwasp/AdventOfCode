//
//  main.swift
//  Day_22
//
//  Created by Pavlo Liashenko on 22.12.2023.
//

import Foundation
import AdventOfCodeStarterPack

struct Brick: Hashable {
    var from: Position3D
    var to: Position3D
}

extension Brick {
    init(_ str: String) {
        let comps = str.components(separatedBy: "~").map{Position3D($0)!}
        from = comps[0]
        to = comps[1]
    }
}

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL).trimmingCharacters(in: .whitespacesAndNewlines)
var bricks = inputFileData.components(separatedBy:.newlines).map{Brick($0)}
bricks.sort { min($0.from.z, $0.to.z) < min($1.from.z, $1.to.z)}

let maxX = max(bricks.map{$0.from.x}.max()!, bricks.map{$0.to.x}.max()!)
let maxY = max(bricks.map{$0.from.y}.max()!, bricks.map{$0.to.y}.max()!)
let maxZ = max(bricks.map{$0.from.z}.max()!, bricks.map{$0.to.z}.max()!)

var field: [[[Bool]]] = Array(repeating: Array(repeating: Array(repeating: false, count: maxX+1), count: maxY+1), count: maxZ+1)

func fill(_ field: inout [[[Bool]]], _ brick: Brick, _ value: Bool) {
    for z in brick.from.z...brick.to.z {
        for y in brick.from.y...brick.to.y {
            for x in brick.from.x...brick.to.x {
                field[z][y][x] = value
            }
        }
    }
}

func isFree(_ field: [[[Bool]]], _ brick: Brick) -> Bool {
    guard brick.from.z > 0 && brick.to.z > 0 else {return false}
    for z in brick.from.z...brick.to.z {
        for y in brick.from.y...brick.to.y {
            for x in brick.from.x...brick.to.x {
                if field[z][y][x] {
                    return false
                }
            }
        }
    }
    return true
}

func down(_ brick: Brick) -> Brick {
    var brick = brick
    brick.from.z -= 1
    brick.to.z -= 1
    return brick
}

for brick in bricks {
    if isFree(field, brick) {
        fill(&field, brick, true)
    } else {
        print("Error \(brick)")
    }
}

var exit = false
while !exit {
    exit = true
    for index in 0..<bricks.count {
        var brick = bricks[index]
        fill(&field, brick, false)
        var move = brick
        while isFree(field, move) {
            brick = move
            move = down(move)
        }
        fill(&field, brick, true)
        if (bricks[index] != brick) {
            bricks[index] = brick
            exit = false
        }
    }
}

func fill(_ brick: Brick, _ value: Int) {
    for z in brick.from.z...brick.to.z {
        for y in brick.from.y...brick.to.y {
            for x in brick.from.x...brick.to.x {
                rField[z][y][x] = value
            }
        }
    }
}

var rField: [[[Int]]] = Array(repeating: Array(repeating: Array(repeating: -1, count: maxX+1), count: maxY+1), count: maxZ+1)

for (index, brick) in bricks.enumerated()  {
    fill(brick, index)
}

var reletions : [Set<Int>] = Array(repeating: [], count: bricks.count)
for (index, brick) in bricks.enumerated() {
    for z in brick.from.z...brick.to.z {
        for y in brick.from.y...brick.to.y {
            for x in brick.from.x...brick.to.x {
                if rField[z-1][y][x] != -1 && rField[z-1][y][x] != index {
                    reletions[index].insert(rField[z-1][y][x])
                }
            }
        }
    }
}

var count = 0
for i in 0..<bricks.count {
    var safely = true
    for j in 0..<bricks.count {
        if reletions[j].count == 1 && reletions[j].contains(i) {
            safely = false
            break
        }
    }
    if safely {
        count += 1
    }
}
print("Day_22_1: \(count)")//411

var sum = 0
for (index, toRemove) in bricks.enumerated() {
    var bricks = bricks
    bricks.remove(at: index)
    var field = field
    fill(&field, toRemove, false)
    var fall: Set<Int> = []
    var exit = false
    while !exit {
        exit = true
        for index in 0..<bricks.count {
            var brick = bricks[index]
            fill(&field, brick, false)
            var move = brick
            while isFree(field, move) {
                brick = move
                move = down(move)
            }
            fill(&field, brick, true)
            if (bricks[index] != brick) {
                bricks[index] = brick
                fall.insert(index)
                exit = false
            }
        }
    }
    sum += fall.count
}
print("Day_22_2: \(sum)")//47671
