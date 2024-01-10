//
//  main.swift
//  Day_11
//
//  Created by Pavlo Liashenko on 11.12.2023.
//

import Foundation
import AdventOfCodeStarterPack

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL).trimmingCharacters(in: .whitespacesAndNewlines)
var grid = inputFileData.components(separatedBy:.newlines).map{$0.map{$0 == "#"}}
var size = grid.size
var emptyColumns = Set(0..<size.x)
var emptyRows = Set(0..<size.y)
var galaxies: [Position] = []
for y in 0..<size.y {
    for x in 0..<size.x {
        let pos = Position(x, y)
        if grid[pos] {
            galaxies.append(pos)
            emptyColumns.remove(x)
            emptyRows.remove(y)
        }
    }
}

func sum(factor: Int) -> Int {
    var sum = 0
    let factor = factor - 1
    for i in 0 ..< (galaxies.count-1) {
        for j in (i+1) ..< galaxies.count {
            let offset = galaxies[i] - galaxies[j]
            let length = abs(offset.x) + abs(offset.y)
            sum += length
            let xRange = min(galaxies[i].x, galaxies[j].x)..<max(galaxies[i].x, galaxies[j].x)
            let yRange = min(galaxies[i].y, galaxies[j].y)..<max(galaxies[i].y, galaxies[j].y)
            let emptyColumns = emptyColumns.intersection(xRange)
            let emptyRows = emptyRows.intersection(yRange)
            sum += emptyColumns.count*factor
            sum += emptyRows.count*factor
        }
    }
    return sum
}

var result1 = sum(factor: 2)
print("Day_11_1: \(result1)")//9742154

var result2 = sum(factor: 1000000)
print("Day_11_2: \(result2)")//411142919886
