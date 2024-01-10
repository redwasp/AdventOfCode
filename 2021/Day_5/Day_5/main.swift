//
//  main.swift
//  Day_5
//
//  Created by Pavlo Liashenko on 05.12.2021.
//

import Foundation

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL)
var dataLines = inputFileData.split(separator:"\n" , omittingEmptySubsequences: true)

let lines = dataLines.map {
    $0.components(separatedBy:" -> ").map {
        $0.components(separatedBy: ",").map {
            Int($0)!
        }
    }
}

var field : [[Int]] = Array(repeating: Array(repeating: 0, count: 1000), count: 1000)
for line in lines {
    let x1 = line[0][0]
    let y1 = line[0][1]
    let x2 = line[1][0]
    let y2 = line[1][1]
    if x1 == x2  {
        for y in range(y1, y2) {
            field[y][x1] += 1
        }
    } else if y1 == y2  {
        for x in range(x1, x2) {
            field[y1][x] += 1
        }
    }
}

let result1 = field.reduce(0){$0 + $1.reduce(0){ $0 + ($1 > 1 ? 1 : 0)}}
print("Day5_1: \(result1)")


field = Array(repeating: Array(repeating: 0, count: 1000), count: 1000)
for line in lines {
    let x1 = line[0][0]
    let y1 = line[0][1]
    let x2 = line[1][0]
    let y2 = line[1][1]
    if x1 == x2  {
        for y in range(y1, y2) {
            field[y][x1] += 1
        }
    } else if y1 == y2  {
        for x in range(x1, x2) {
            field[y1][x] += 1
        }
    } else {
        let dX = x1 < x2 ? 1 : -1
        let dY = y1 < y2 ? 1 : -1
        var x = x1
        var y = y1
        while x != x2 && y != y2 {
            field[y][x] += 1
            x += dX
            y += dY
        }
        field[y2][x2] += 1
    }
}

let result2 = field.reduce(0){$0 + $1.reduce(0){ $0 + ($1 > 1 ? 1 : 0)}}
print("Day5_2: \(result2)")

func range(_ x1: Int, _ x2: Int) -> ClosedRange<Int> {
    if x1 <= x2 {
        return x1...x2
    } else {
        return x2...x1
    }
}
