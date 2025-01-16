//
//  main.swift
//  Day_25
//
//  Created by Pavlo Liashenko on 25.12.2024.
//

import Foundation

let inputFileURL  = URL(fileURLWithPath: "input1.txt")
let inputFileData = try! String(contentsOf: inputFileURL, encoding: .utf8).trimmingCharacters(in: .whitespacesAndNewlines)
let schemas = inputFileData.split(separator: "\n\n").map{$0.components(separatedBy:.newlines).map{$0.map{$0}}}
let keysSchemas = schemas.filter{$0[0][0] == "."}
let locksSchemas = schemas.filter{$0[0][0] == "."}

var keys: [[Int]] = []
var locks: [[Int]] = []

for schema in schemas {
    var heights: [Int] = [-1,-1,-1,-1,-1]
    for x in 0...4 {
        for y in 0...6 {
            if schema[y][x] == "#" {
                heights[x] += 1
            }
        }
    }
    if schema[0][0] == "." {
        keys.append(heights)
    } else {
        locks.append(heights)
    }
}

var count = 0
for key in keys {
    exit: for lock in locks {
        for i in 0...4 {
            if key[i] + lock[i] > 5 {
                continue exit
            }
        }
        count += 1
    }
}

print("Day_25_1:", count)
