//
//  main.swift
//  Day_8
//
//  Created by Pavlo Liashenko on 10.12.2024.
//

import Foundation
import AdventOfCodeStarterPack

let inputFileURL  = URL(fileURLWithPath: "input1.txt")
let inputFileData = try! String(contentsOf: inputFileURL, encoding: .utf8).trimmingCharacters(in: .whitespacesAndNewlines)
var field = inputFileData.components(separatedBy:.newlines).map{$0.map{$0}}
var map: [Character: [Position]] = [:]
var set: Set<Position> = []
for y in field.indices {
    for x in field[y].indices {
        let pos = Position(x: x, y: y)
        let antenna = field[pos]
        guard antenna != "." else {continue}
        for p in map[antenna, default: []] {
            let dp = pos - p
            let antinode1 = p   - dp
            if field.valid(position:antinode1) {
                set.insert(antinode1)
            }
            let antinode2 = pos + dp
            if field.valid(position:antinode2) {
                set.insert(antinode2)
            }
        }
        map[antenna, default: []].append(pos)
    }
}

print("Day_8_1:", set.count)

map = [:]
set = []
for y in field.indices {
    for x in field[y].indices {
        let pos = Position(x: x, y: y)
        let antenna = field[pos]
        guard antenna != "." else {continue}
        for p in map[antenna, default: []] {
            let dp = pos - p
            var antinode1 = p
            while field.valid(position:antinode1) {
                set.insert(antinode1)
                antinode1 -= dp
            }
            var antinode2 = pos
            while field.valid(position:antinode2) {
                set.insert(antinode2)
                antinode2 += dp
            }
        }
        map[antenna, default: []].append(pos)
    }
}

print("Day_8_2:", set.count)
