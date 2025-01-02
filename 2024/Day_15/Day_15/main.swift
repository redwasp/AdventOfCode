//
//  main.swift
//  Day_15
//
//  Created by Pavlo Liashenko on 16.12.2024.
//

import Foundation
import AdventOfCodeStarterPack

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL, encoding: .utf8).trimmingCharacters(in: .whitespacesAndNewlines)
let data = inputFileData.split(separator:"\n\n")
var start = Position.zero
let lines = data[0].split(separator:"\n")

enum Cell {
case empty
case wall
case box
}
var field: [[Cell]] = []
for (y, line) in lines.enumerated() {
    field.append([])
    for (x, char) in line.enumerated() {
        let cell = switch char {
            case "#" : Cell.wall
            case "O" : Cell.box
            default  : Cell.empty
        }
        field[y].append(cell)
        if char == "@" {
            start = Position(x, y)
        }
    }
}

let path = data[1].compactMap{Direction($0)}
var pos = start
for dir in path {
    let nextPos = pos + dir
    switch field[nextPos] {
    case .empty:
        pos = nextPos
    case .box:
        var moveTo = nextPos + dir
        while field[moveTo] == .box {
            moveTo += dir
        }
        if field[moveTo] == .empty {
            field[moveTo] = .box
            field[nextPos] = .empty
            pos = nextPos
        }
    case .wall:
        break
    }
}
var result1 = 0
for (y, row) in field.enumerated() {
    for (x, cell) in row.enumerated() {
        if cell == .box {
            result1 += y*100 + x
        }
    }
}


print("Day_15_1:", result1)

enum Cell2 {
case empty
case wall
case boxLeft
case boxRight
}

var field2: [[Cell2]] = []
for (y, line) in lines.enumerated() {
    field2.append([])
    for (x, char) in line.enumerated() {
        switch char {
            case "#" :
            field2[y].append(.wall)
            field2[y].append(.wall)
            case "O" :
            field2[y].append(.boxLeft)
            field2[y].append(.boxRight)
            default  :
                field2[y].append(.empty)
                field2[y].append(.empty)
        }
        if char == "@" {
            start = Position(x*2, y)
        }
    }
}

func canMove(to pos: Position, _ dir: Direction) -> Bool {
    switch field2[pos] {
    case .empty:
        return true
    case .wall:
        return false
    case .boxLeft:
        if dir == .right {
            return canMove(to: pos + dir + .right, dir)
        } else {
            return canMove(to: pos + dir, dir) && canMove(to: pos + dir + .right, dir)
        }
    case .boxRight:
        if dir == .left {
            return canMove(to: pos + dir + .left, dir)
        } else {
            return canMove(to: pos + dir, dir) && canMove(to: pos + dir + .left, dir)
        }
    }
}

func moveBoxes(to pos: Position, _ dir: Direction) {
    switch field2[pos] {
    case .boxLeft:
        if dir == .right {
            moveBoxes(to: pos + .right + dir, dir)
        } else {
            moveBoxes(to: pos + .right + dir, dir)
            moveBoxes(to: pos + dir, dir)
        }
        field2[pos] = .empty
        field2[pos + .right] = .empty
        field2[pos + .right + dir] = .boxRight
        field2[pos + dir] = .boxLeft
    case .boxRight:
        if dir == .left {
            moveBoxes(to: pos + .left + dir, dir)
        } else {
            moveBoxes(to: pos + .left + dir, dir)
            moveBoxes(to: pos + dir, dir)
        }
        field2[pos] = .empty
        field2[pos + .left] = .empty
        field2[pos + .left + dir] = .boxLeft
        field2[pos + dir] = .boxRight
    default:
        break
    }
}

pos = start

for dir in path {
    let nextPos = pos + dir
    if canMove(to: nextPos, dir) {
        moveBoxes(to: nextPos, dir)
        if (dir == .down || dir == .up) {
            if (field2[nextPos] == .boxLeft) {
                field2[nextPos + .right] = .empty
            } else if (field2[nextPos] == .boxRight) {
                field2[nextPos + .left] = .empty
            }
        }
        field2[nextPos] = .empty
        pos = nextPos
    }
}

var result2 = 0
for (y, row) in field2.enumerated() {
    for (x, cell) in row.enumerated() {
        if cell == .boxLeft {
            result2 += y*100 + x
        }
    }
}

print("Day_15_2:", result2)

func frintField() {
    var str = ""
    for y in field2.indices {
         for x in field2[y].indices {
             if pos.x == x && pos.y == y {
                 str += "@"
             } else {
                 switch field2[y][x] {
                 case .empty:
                     str += "."
                 case .boxLeft:
                     str += "["
                 case .boxRight:
                     str += "]"
                 case .wall:
                     str += "#"
                 }
             }
         }
        str += "\n"
    }
     print("\(str)\n")
}
