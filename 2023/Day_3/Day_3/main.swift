//
//  main.swift
//  Day_3
//
//  Created by Pavlo Liashenko on 03.12.2023.
//

import Foundation

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL).trimmingCharacters(in: .whitespacesAndNewlines)
let grid = inputFileData.components(separatedBy: .newlines).map{$0.map{$0}}
var result1 = 0;
for y in 0..<grid.count {
    let row = grid[y]
    var number = 0
    var valid = false
    for x in 0..<row.count {
        if row[x].isNumber {
            number *= 10
            number += row[x].wholeNumberValue!
            if (!valid) {
                for dx in -1...1 {
                    for dy in -1...1 {
                        let yy = y + dy
                        let xx = x + dx
                        if grid.indices.contains(yy),
                           row.indices.contains(xx) {
                            if !grid[yy][xx].isNumber && grid[yy][xx] != "." {
                                valid = true
                                break
                            }
                        }
                        if (valid) {break}
                    }
                }
            }
        } else {
            if (valid) {
                result1 += number;
            }
            number = 0
            valid = false
        }
    }
    if (valid) {
        result1 += number;
    }
    number = 0
    valid = false
}
print("Day_3_1: \(result1)")//546563

var result2 = 0;
var index = 0
var indexes : [[Int]] = []
var numbers : [Int] = []
for y in 0..<grid.count {
    let row = grid[y]
    var number = 0
    indexes.append([])
    for x in 0..<row.count {
        if row[x].isNumber {
            number *= 10
            number += row[x].wholeNumberValue!
            indexes[y].append(index);
        } else {
            if (number != 0) {
                index += 1
                numbers.append(number)
            }
            number = 0
            indexes[y].append(-1);
        }
    }
    if (number != 0) {
        index += 1
        numbers.append(number)
    }
    number = 0
}
for y in 0..<grid.count {
    let row = grid[y]
    indexes.append([])
    for x in 0..<row.count {
        if row[x] == "*" {
            var set: Set<Int> = []
            for dy in -1...1 {
                for dx in -1...1 {
                    let yy = y + dy
                    let xx = x + dx
                    if grid.indices.contains(yy),
                       row.indices.contains(xx) {
                        if indexes[yy][xx] != -1 {
                            set.insert(indexes[yy][xx])
                        }
                    }
                }
            }
            if set.count == 2 {
                result2 += set.map{numbers[$0]}.reduce(1, *)
            }
        }
    }
}
print("Day_3_2: \(result2)")//91031374
