//
//  main.swift
//  Day_10
//
//  Created by Pavlo Liashenko on 10.12.2023.
//

import Foundation
import AdventOfCodeStarterPack

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL).trimmingCharacters(in: .whitespacesAndNewlines)
var grid = inputFileData.components(separatedBy:.newlines).map{$0.map{TileKind(char: $0)}}

enum TileKind {
    case northAndSouth
    case eastAndWest
    case northAndEast
    case northAndWest
    case southAndWest
    case southAndEast
    case ground
    case startingPosition

    init(char: Character) {
        switch char {
        case "|":
            self = .northAndSouth
        case "-":
            self = .eastAndWest
        case "L":
            self = .northAndEast
        case "J":
            self = .northAndWest
        case "7":
            self = .southAndWest
        case "F":
            self = .southAndEast
        case "S":
            self = .startingPosition
        default:
            self = .ground
        }
    }
    
    func next(_ direction: Position) -> Position {
        switch (self, direction) {
            
        case (.northAndSouth, .north),
             (.northAndEast, .west),
             (.northAndWest, .east):
                .north
            
        case (.northAndSouth, .south),
             (.southAndWest, .east),
             (.southAndEast, .west):
                .south
            
        case (.eastAndWest, .east),
             (.northAndEast, .south),
             (.southAndEast, .north):
                .east
            
        case (.eastAndWest, .west),
             (.northAndWest, .south),
             (.southAndWest, .north):
                .west
            
        default:
                .zero
        }
    }
}

let maxY = grid.count
let maxX = grid.first!.count
var start: Position = .zero;
for y in 0..<maxY {
    for x in 0..<maxX {
        if grid[y][x] == .startingPosition {
            start = Position(x, y)
            break;
        }
    }
}

var from = start
var to : Position = .zero
for direction in Directions.clockwise {
    to = from + direction
    let tile = grid[safe: to]
    if tile != nil
    && tile!.next(direction) != .zero {
        break;
    }
}
var step  = 1
var grid2  = Array(repeating: Array(repeating: Position.zero, count: maxX), count: maxY)
var grid4  = Array(repeating: Array(repeating: TileKind.ground, count: maxX), count: maxY)
var direction = Position.zero
while grid[to] != .startingPosition {
    direction = to - from
    grid2[from] = direction
    grid4[from] = grid[from]
    (from, to) = (to, to + grid[to].next(direction))
    step += 1
}
grid2[from] = to - from
grid4[from] = grid[from]

print("Day_10_1: \(step/2)");//6768

var isClockwise: Bool!
for y in 0..<maxY {
    for x in 0..<maxX {
        switch grid2[y][x] {
        case .up, .right:
            isClockwise = true
        case .down, .left:
            isClockwise = false
        default:
            continue;
        }
        if isClockwise != nil {
            break;
        }
    }
    if isClockwise != nil {
        break;
    }
}

var field = grid2.map {
    $0.map {
        switch $0 {
            case .down: "↓"
            case .up: "↑"
            case .left: "←"
            case .right: "→"
            default: " "
        }
    }.joined()
}.joined(separator:"\n")

print(field)
var grid22 = grid2
var grid3 = Array(repeating: Array(repeating: false, count: maxX), count: maxY)
var position = start + grid2[start]
direction = grid2[start]
var previosDirection = Position.zero
var perpendicular = Position.zero
var x = Position.zero
while position != start {
    previosDirection = direction
    direction = grid2[position]
    for direction in [previosDirection, direction] {
        if isClockwise {
            perpendicular = direction.rotatedRight()
        } else {
            perpendicular = direction.rotatedLeft()
        }
        x = position + perpendicular
        while grid2[safe: x] == .zero {
            grid3[x] = true
            grid22[x] = .upLeft
            x += perpendicular
        }
    }
    position += direction
}

field = grid3.map {
    $0.map {
        $0 ? "#" : " "
   }.joined()
}.joined(separator:"\n")

print(field)

let count = grid3.reduce(0) {
    $0 + $1.reduce(0) {
        $0 + ($1 ? 1 : 0)
    }
}

print("Day_10_2: \(count)")//351

field = grid22.map {
    $0.map {
        switch $0 {
            case .down: "↓"
            case .up: "↑"
            case .left: "←"
            case .right: "→"
            case .upLeft: "#"
            default: " "
        }
    }.joined()
}.joined(separator:"\n")
print(field)

var grid5 = grid4.map {
    $0.map {
        switch $0 {
        case .northAndSouth:
             "│"
        case .eastAndWest:
             "─"
        case .northAndEast:
             "└"
        case .northAndWest:
            "┘"
        case .southAndWest:
            "┐"
        case .southAndEast:
            "┌"
        case .ground:
            "."
        case .startingPosition:
            "*"
        }
    }
}

for y in 0..<maxY {
    for x in 0..<maxX {
        if grid3[y][x] {
            grid5[y][x] = "#"
        }
    }
}
    
field = grid5.map{$0.joined()}.joined(separator:"\n")
print(field)
