//
//  main.swift
//  Day_21
//
//  Created by Pavlo Liashenko on 21.12.2023.
//

import Foundation
import AdventOfCodeStarterPack

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL).trimmingCharacters(in: .whitespacesAndNewlines)
let field = inputFileData.components(separatedBy:.newlines).map{$0.map{$0}}
var start: Position = .zero
var map: [[Bool]] = []
for y in 0..<field.count {
    map.append([])
    for x in 0..<field[y].count {
        if field[y][x] == "S" {
            start = Position(x, y)
        }
        map[y].append(field[y][x] == "#")
    }
}
let size = map.count

func gardenPlots(_ steps: Int) -> [Position] {
    //var prevCount = 0
    var positions: [Position] = [start]
    for _ in 0..<steps {
        var newPositions: Set<Position> = []
        for position in positions {
            for dir in Directions.clockwise {
                let newPosition = position + dir
                if !map[mod:newPosition]  {
                    newPositions.insert(newPosition)
                }
            }
        }

        positions = Array(newPositions)
    }
    return positions
}
print("Day_21_1: \(gardenPlots(64).count)")//3600

func gardenPlotsCount(_ steps: Int) -> Int {
    let offset = start.x - 1
    let n = (steps - offset)/size
    let testPlots = gardenPlots(2*size + steps%size)
    let matrix = matrix(testPlots)
    print(matrix: matrix)
    let center = matrix.size / 2
    let a1 = matrix[center.up()]//7335
    let a2 = matrix[center]//7320
    let a3 = matrix[center.offset(1, -2)] + matrix[center.offset(2, 1)] + matrix[center.offset(-1, 2)] + matrix[center.offset(-2, -1)]
    let a4 = matrix[center.offset(1, -1)] + matrix[center.offset(1, 1)] + matrix[center.offset(-1, 1)] + matrix[center.offset(-1, -1)]
    let a5 = matrix[center.offset(y: -2)] + matrix[center.offset(x: 2)] + matrix[center.offset(y: 2)] + matrix[center.offset(x: -2)]
    let a6 = matrix[center.offset(y: -3), default: 0] + matrix[center.offset(x: 3), default: 0] + matrix[center.offset(y: 3), default: 0] + matrix[center.offset(x: -3), default: 0]
    //a1*x^2 + a2*(x-1)^2 + a3*x + a4*(x-1) + a5 + a6
    var x = 0
    x += a1*n*n
    x += a2*(n-1)*(n-1)
    x += a3*n
    x += a4*(n-1)
    x += a5
    x += a6
    return x
}

//    .    .    .    168  .    .    .
//    .    .    1511 6289 1523 .    .
//    .    1511 6742 7082 6740 1523 .
//    164  6288 7082 7193 7082 6301 167
//    .    1500 6739 7082 6754 1506 .
//    .    .    1500 6300 1506 .    .
//    .    .    .    162  .    .    .

print("Day_21_2: \(gardenPlotsCount(26501365))")//599763113936220

func matrix(_ positions: [Position]) -> [[Int]] {
    let size = field.size
    let minX = positions.min(by:{$0.x < $1.x})!.x
    let maxX = positions.min(by:{$0.x > $1.x})!.x
    let minY = positions.min(by:{$0.y < $1.y})!.y
    let maxY = positions.min(by:{$0.y > $1.y})!.y
    let offsetX = -minX/size.x + (-minX % size.x != 0 ? 1 : 0)
    let offsetY = -minY/size.y + (-minY % size.y != 0 ? 1 : 0)
    let width  = offsetX + maxX/size.x + ((maxX-1) % size.x != 0 ? 1 : 0)
    let height = offsetY + maxY/size.y + ((maxY-1) % size.y != 0 ? 1 : 0)
    var matrix = Array(repeating: Array(repeating: 0, count: width), count: height)
    for position in positions {
        let mPos = Position((offsetX*size.x + position.x)/size.x, (offsetY*size.y + position.y)/size.y)
        matrix[mPos] += 1
    }
    return matrix
}

func print(matrix: [[Int]]) {
    var str = ""
    for y in 0..<matrix.count {
        for x in 0..<matrix[0].count {
            var item = matrix[y][x] != 0 ? String(matrix[y][x]) : " "
            while item.count < 5 {
                item += " "
            }
            str += item
        }
        str += "\n"
    }
    print(str)
}
