//
//  main.swift
//  Day_6
//
//  Created by Pavlo Liashenko on 1/24/25.
//

import Foundation
import AdventOfCodeStarterPack

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL, encoding: .utf8).trimmingCharacters(in: .whitespacesAndNewlines)
let points = inputFileData.components(separatedBy: .newlines).map{$0.split(separator:", ").map{Int($0)!}}.map{Position($0[0],$0[1])}
print(points)

var items : [Position: Int] = [:]
var counts : [Int] = Array(repeating: 1, count: points.count)
var isInfinite : Set<Int> = []
var field : [[Int]] = Array.init(repeating: Array.init(repeating: 0, count: 500), count: 500)
for (index, point) in points.enumerated() {
    items[point] = index
    field[point] = index
}
while items.count > 0 {
    var newItems : [Position: Int] = [:]
    for (position, id) in items {
        for offset in Directions.clockwise {
            let p = position + offset
            guard field.valid(position: p) else {
                isInfinite.insert(id)
                continue
            }
            guard field[p] == 0 else {continue}
            guard newItems[p] == nil || newItems[p] == id else {
                field[p] = -1
                newItems[p] = nil
                continue
            }
            newItems[p] = id
        }
    }
    for (position, id) in newItems {
        field[position] = id
        counts[id] += 1
    }
    items = newItems
}
var maxAera = 0
for index in 0..<counts.count {
    guard !isInfinite.contains(index) else {continue}
    maxAera = max(maxAera, counts[index])
}

print("Day_6_1:", maxAera)

field = Array.init(repeating: Array.init(repeating: 0, count: 500), count: 500)
var count = 0;
let minX = points.map{$0.x}.min()!
let maxX = points.map{$0.x}.max()!
let minY = points.map{$0.y}.min()!
let maxY = points.map{$0.y}.max()!
for x in minX...maxX {
    for y in minY..<maxY {
        var sum = 0
        for p in points {
            let d = abs(p.x - x) + abs(p.y - y)
            sum += d
        }
        if (sum < 10000) {
            count += 1;
        }
        field[x][y] = sum
    }
}

print("Day_6_2:", count)
