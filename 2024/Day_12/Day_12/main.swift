//
//  main.swift
//  Day_12
//
//  Created by Pavlo Liashenko on 12.12.2024.
//

import Foundation
import AdventOfCodeStarterPack

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL, encoding: .utf8).trimmingCharacters(in: .whitespacesAndNewlines)
var farm = inputFileData.components(separatedBy: .newlines).map{$0.map{$0}}
var height = farm.count
var width = farm[0].count
var result: (Int, Int) = (0, 0)
var used = Array(repeating: Array(repeating: false, count: width), count: height)
var aera = 0
var perimeter: (Int, Int) = (0, 0)
var poss: Set<Position> = []
var plant: Character = " "
var pos = Position.zero
for y in 0..<height {
    for x in 0..<width {
        pos = Position(x, y)
        guard !used[pos] else {continue}
        plant = farm[pos]
        poss = [pos]
        aera = 0
        perimeter = (0, 0)
        while poss.count > 0 {
            var newPoss: Set<Position> = []
            for pos in poss {
                for dir in Directions.clockwise {
                    let newPos = pos + dir
                    if farm[safe: newPos] != plant {
                        perimeter.0 += 1
                        let prevPos = pos + dir.rotatedLeft()
                        if farm[safe: prevPos] != plant || farm[safe: prevPos + dir] == plant {
                            perimeter.1 += 1
                        }
                    } else {
                        if !used[newPos] {
                            newPoss.insert(newPos)
                        }
                    }
                }
                aera += 1
                used[pos] = true
            }
            poss = newPoss
        }
        result.0 += aera*perimeter.0
        result.1 += aera*perimeter.1
    }
}

print("Day_12_1:", result.0)//1461806
print("Day_12_1:", result.1)//887932
