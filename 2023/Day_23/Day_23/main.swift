//
//  main.swift
//  Day_23
//
//  Created by Pavlo Liashenko on 23.12.2023.
//

import Foundation
import AdventOfCodeStarterPack

enum Tile: Equatable {
    case path
    case slope(Position)
    case forest

    init(_ char: Character) {
        switch char {
        case ".":
            self = .path
        case ">":
            self = .slope(.right)
        case "<":
            self = .slope(.left)
        case "^":
            self = .slope(.up)
        case "v":
            self = .slope(.down)
        default:
            self = .forest
        }
    }
}

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL).trimmingCharacters(in: .whitespacesAndNewlines)
var field = inputFileData.components(separatedBy:.newlines).map{$0.map{Tile($0)}}
var start = Position(1, 0)
var end = Position(field.size.x-2, field.size.y-1)
var map = Array(repeating: Array(repeating: 0, count: field.size.x), count: field.size.y)

struct Step: Hashable {
    var position: Position
    var previos: Position
    var checkPoints: Set<Position>
    
    init(_ position: Position, _ previos: Position, _ checkPoints: Set<Position>) {
        self.position = position
        self.previos = previos
        self.checkPoints = checkPoints
    }
    
    func move(_ direction: Position) -> Step {
        let previos = position
        let position = position + direction
        var checkPoints = checkPoints
        var count = 0
        for direction in Directions.clockwise {
            let tile = field[safe: position + direction]
            if tile != nil && tile != .forest {
                count += 1
            }
        }
        if count > 2 {
            checkPoints.insert(position)
        }
        return Step(position, previos, checkPoints)
    }
}

func next(_ step: Step) -> [Step] {
    switch field[step.position] {
    case .path:
        var steps: [Step] = []
        for direction in Directions.clockwise {
            let next = step.move(direction)
            guard next.position != step.previos else {continue}
            guard !step.checkPoints.contains(next.position) else {continue}
            switch field[safe: next.position] {
            case .path:
                    steps.append(next)
            case .slope(let dir):
                if dir == direction {
                    steps.append(next)
                }
            default:
                break
            }
        }
        return steps
    case .slope(let direction):
        return [step.move(direction)]
    default:
        return []
    }
}

func longestHike(_ next:(Step) -> [Step]) -> Int {
    var steps: [Step] = [Step(start, Position(x:1, y:-1) ,[])]
    var count = 0
    var lastEnd = 0
    var nextSteps: [Step] = []
    while steps.count != 0 {
        count += 1
        nextSteps = []
        for step in steps {
            if step.position == end {
                lastEnd = count
            } else {
                nextSteps.append(contentsOf: next(step))
            }
        }
        steps = nextSteps
    }
    return lastEnd-1
}

print("Day_23_1: \(longestHike(next))")//2130

var nodes: [Position] = []
for y in 0..<field.count {
    for x in 0..<field[y].count {
        let position = Position(x, y)
        var count = 0
        for direction in Directions.clockwise {
            let tile = field[safe: position + direction]
            if tile != nil && tile != .forest {
                count += 1
            }
        }
        if count > 2 {
            nodes.append(position)
        }
    }
}
nodes.insert(start, at: 0)
nodes.append(end)
var last = nodes.count - 1

var graph: [Set<Int>] = Array(repeating: [], count: nodes.count)
var weights: [[Int]] = Array(repeating: Array(repeating: 0, count: nodes.count), count: nodes.count)
var nodesSet = Set(nodes)

for (index, node) in nodes.enumerated() {
    var positions = [node]
    var weight = 0
    var used: Set<Position> = [node]
    while positions.count > 0 {
        weight += 1
        var newPositions: [Position] = []
        for position in positions {
            for direction in Directions.clockwise {
                let next = position + direction
                guard !used.contains(next) else {continue}
                let tile = field[safe: next]
                if tile != nil && tile != .forest {
                    if nodesSet.contains(next) {
                        let nextIndex = nodes.firstIndex(of: next)!
                        graph[index].insert(nextIndex)
                        weights[index][nextIndex] = weight
                        weights[nextIndex][index] = weight
                    } else {
                        newPositions.append(next)
                    }
                }

         
            }
        }
        used.formUnion(newPositions)
        positions = newPositions
    }
}
var max = 0
func find(_ sum: Int, _ position: Int, _ available: Set<Int>) {
    if position == last {
        if sum > max {
            max = sum
        }
        return
    }
    let nodes = graph[position].intersection(available)
    for node in nodes {
        var available = available
        available.remove(node)
        find(sum+weights[position][node], node, available)
    }
}

var available = Set(1..<nodes.count)
find(0, 0, available)
print("Day_23_2: \(max)")//6710
