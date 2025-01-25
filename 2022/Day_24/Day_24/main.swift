//
//  main.swift
//  Day_24
//
//  Created by Pavlo Liashenko on 24.12.2022.
//

import Foundation
import AdventOfCodeStarterPack

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL).trimmingCharacters(in: .whitespacesAndNewlines)
var grid   = inputFileData.components(separatedBy:.newlines).map{$0.map{$0}}
let width  = grid[0].count-2
let height = grid.count-2
var size = Position(width, height)
var field = Position.zero...(size - .one)

struct Blizzard: Hashable {
    let direction: Position
    var position: Position

    init(_ position: Position, _ direction: Direction) {
        self.position = position
        self.direction = direction
    }
    
    var next: Blizzard {
        var next = self
        next.position = (position + direction) %% size
        return next
    }
}

var blizzards: [Blizzard] = []

for y in 0..<height {
    for x in 0..<width {
        let position = Position(x, y)
        guard let direction = Direction(grid[position.downRight]) else {continue}
        let blizzard = Blizzard(position, direction)
        blizzards.append(blizzard)
    }
}

let start: Position = field.lowerBound.up
let end:   Position = field.upperBound.down

var result = steps(from: start, to: end, strategy: .downRight)
print("Day_24_1: \(result)")//242

result += steps(from: end,   to: start, strategy: .upLeft)
result += steps(from: start, to: end, strategy: .downRight)
print("Day_24_2: \(result)")//720

func steps(from: Position, to target: Position, strategy directions: Directions) -> Int {
    var steps = Set<Position>(blizzards.map{$0.position})
    var positions: Set<Position> = [from]
    var newPositions: Set<Position> = []
    var step = 0
    while true {
        newPositions = []
        for pos in positions {
            for direction in directions {
                let newPosition = pos + direction
                if newPosition == target {
                    return step
                }
                guard field.contains(newPosition), !steps.contains(newPosition) else {continue}
                newPositions.insert(newPosition)
            }
            if !steps.contains(pos) {
                newPositions.insert(pos)
            }
        }
        positions = newPositions
        blizzards = blizzards.map(\.next)
        steps = Set<Position>(blizzards.map(\.position))
        step += 1
    }
    return step
}
