//
//  main.swift
//  Day_23
//
//  Created by Pavlo Liashenko on 23.12.2022.
//

import Foundation
import AdventOfCodeStarterPack

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL).trimmingCharacters(in: .whitespacesAndNewlines)
var grid = inputFileData.components(separatedBy:.newlines).map{$0.map{$0=="#"}}

let width  = grid[0].count
let height = grid.count

var elfs: Set<Position> = []

for y in 0..<height {
    for x in 0..<width {
        if grid[y][x] {
            elfs.insert(Position(x, y))
        }
    }
}

extension Direction {
    var near: Directions {
        switch self {
        case .north:
            return [.northWest, .north, .northEast]
        case .south:
            return [.southWest, .south, .southEast]
        case .west:
            return [.southWest, .west, .northWest]
        case .east:
            return [.southEast, .east, .northEast]
        default:
            return []
        }
    }
}
extension Position {
    var key: Int {
        y<<8 + x
    }
}

func isValid(direction: Direction, at position: Position, in map: Set<Int>) -> Bool {
    for direction in direction.near {
        let position = position + direction
        if map.contains(position.key) {
            return false
        }
    }
    return true
}

var directions: Directions = [.north, .south, .west, .east]

var map: Set<Int> = []
var undoMap : [Int : Set<Int>] = [:]
var newPossitions : [Position] = Array(elfs)
var possitions: [Position] = []

var newPossition: Position = .zero
var valids: Directions = []
var index = 0
var step = 0

while possitions != newPossitions  {
    step += 1
    undoMap = [:]
    possitions = newPossitions
    newPossitions = []
    map = Set(possitions.map(\.key))
    for (index, possition) in possitions.enumerated() {
        newPossition = possition
        valids = directions.filter{isValid(direction: $0, at: possition, in: map)}
        if valids.count != 4 && valids.count != 0 {
            newPossition += valids.first!
        }
        undoMap[newPossition.key, default: []].insert(index)
        newPossitions.append(newPossition)
    }

    for indexes in undoMap.values {
        guard indexes.count > 1 else {continue}
        for index in indexes {
            newPossitions[index] = possitions[index]
        }
    }
    
    directions.append(directions.removeFirst())
   
    if (step == 10) {
        print("Day_23_1: \(res(newPossitions))")//3882//3990
    }
}

func res(_ elfs: [Position]) -> Int {
    var maxX = 0
    var maxY = 0
    var minX = Int.max
    var minY = Int.max
    for elf in elfs {
        if elf.x > maxX {maxX = elf.x}
        if elf.x < minX {minX = elf.x}
        if elf.y > maxY {maxY = elf.y}
        if elf.y < minY {minY = elf.y}
    }
    //print("\(minX)...\(maxX), \(minY)...\(maxY)")
    return (maxX-minX+1)*(maxY-minY+1) - elfs.count
}

print("Day_23_2: \(step)")//1116//1057
