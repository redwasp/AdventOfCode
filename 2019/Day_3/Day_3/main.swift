//
//  main.swift
//  Day_3
//
//  Created by Pavlo Liashenko on 1/27/25.
//

import Foundation
import AdventOfCodeStarterPack

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL, encoding: .utf8).trimmingCharacters(in: .whitespacesAndNewlines)
var wires: [[(dir: Direction, count: Int)]] = inputFileData.components(separatedBy:.newlines).map{$0.components(separatedBy:",").map{(dir: Direction($0[$0.startIndex])!, count: Int($0[$0.index(after: $0.startIndex)...])!)}}

var field : [[Int]] = Array(repeating: Array(repeating:-1, count: 32000), count: 32000)
var centralPort = Position(16000, 16000)

var minDistance = Int.max
var pos = centralPort
var steps = 0
for (dir, count) in wires[0] {
    for _ in 0..<count {
        steps += 1
        pos += dir
        if field[pos] == -1 {
            field[pos] = steps
        }
    }
}

var minSteps = Int.max
pos = centralPort
steps = 0

for (dir, count) in wires[1] {
    for _ in 0..<count {
        steps += 1
        pos += dir
        if field[pos] != -1 {
           minDistance = min(minDistance, centralPort.distance(to: pos))
           minSteps = min(minSteps, field[pos] + steps)
        }
    }
}

print("Day_3_1:",minDistance)
print("Day_3_2:",minSteps)
