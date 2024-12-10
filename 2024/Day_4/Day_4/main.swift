//
//  main.swift
//  Day_4
//
//  Created by Pavlo Liashenko on 04.12.2024.
//

import Foundation

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL, encoding: .utf8).trimmingCharacters(in: .whitespacesAndNewlines)
let m = inputFileData.components(separatedBy: .newlines).map{$0.map{$0}}
let dxs = [-1, -1,  0,  1, 1, 1, 0, -1]
let dys = [ 0, -1, -1, -1, 0, 1, 1,  1]
var patern = "XMAS"
func count(_ ax : Int, _ ay: Int) -> Int {
    guard m[ay][ax] == "X" else {return 0}
    var count = 0
    exit: for (dx, dy) in zip(dxs, dys) {
        var x = ax
        var y = ay
        for char in patern {
            if !m.indices.contains(y) || !m[y].indices.contains(x) {continue exit}
            if char != m[y][x] {continue exit}
            x += dx
            y += dy
        }
        count += 1
    }
    return count
}
var result1 = 0
let height = m.count
let width = m[0].count
for y in 0..<height {
    for x in 0..<width {
        result1 += count(x, y)
    }
}
print("Day_4_1: \(result1)")

var result2 = 0
for y in 0..<height-2 {
    for x in 0..<width-2 {
        if m[y+1][x+1] == "A",
           (m[y][x] == "M" && m[y+2][x+2] == "S") || (m[y][x] == "S" && m[y+2][x+2] == "M"),
           (m[y+2][x] == "M" && m[y][x+2] == "S") || (m[y+2][x] == "S" && m[y][x+2] == "M")
        {
            result2 += 1
        }
    }
}

print("Day_4_2: \(result2)")
