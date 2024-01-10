//
//  main.swift
//  Day_14
//
//  Created by Pavlo Liashenko on 14.12.2023.
//

import Foundation
import AdventOfCodeStarterPack

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL).trimmingCharacters(in: .whitespacesAndNewlines)
let panel = inputFileData.components(separatedBy:.newlines).map{$0.map{Tile(rawValue: $0)!}}

enum Tile: Character, Hashable {
    case empty = "."
    case cubeShapedRocks = "#"
    case roundedRock = "O"
}

var size = panel.size

func tilt(_ panel: [[Tile]], _ dirrection: Position) -> [[Tile]] {
    var panel = panel
    let yIndexes = dirrection.y == 1 ? Array((0..<size.y).reversed()) : Array((0..<size.y))
    let xIndexes = dirrection.x == 1 ? Array((0..<size.x).reversed()) : Array((0..<size.x))
    for y in yIndexes {
        for x in xIndexes {
            var pos = Position(x, y)
            if panel[pos] == .roundedRock {
                while panel[safe:pos + dirrection] == .empty {
                    panel[pos] = .empty
                    pos += dirrection
                    panel[pos] = .roundedRock
                }
            }
        }
    }
    return panel
}

func printField(_ field: [[Tile]]) {
    print(field.map{$0.reduce(into: ""){$0.append($1.rawValue)}}.joined(separator:"\n"))
}

func totalLoad(_ field: [[Tile]]) -> Int {
    var total = 0;
    for y in 0..<size.y {
        for x in 0..<size.x {
            if field[y][x] == .roundedRock {
                total += size.y - y
            }
        }
    }
    return total
}

print("Day_14_1: \(totalLoad(tilt(panel, .north)))")//109755

var values: [Int] = []
func findLoop(_ panel: [[Tile]]) -> (offset: Int, size: Int) {
    var direction = Position.north
    var panel = panel
    var loop : [[[Tile]]: Int] = [:]
    var index = 0
    while loop[panel] == nil {
        values.append(totalLoad(panel))
        loop[panel] = index
        panel = tilt(panel, direction)
        direction.rotateLeft()
        index += 1
    }
    let loopOffset = loop[panel]!
    let loopSize   = index - loopOffset
    return (loopOffset, loopSize)
}

let options = findLoop(panel)
let cycles = 1000000000
let tilts = cycles * 4
let result2 = values[options.offset + (tilts - options.offset)%options.size]
print("Day_14_2: \(result2)")//90928
