//
//  main.swift
//  Day_19
//
//  Created by Pavlo Liashenko on 19.12.2024.
//

import Foundation

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL, encoding: .utf8).trimmingCharacters(in: .whitespacesAndNewlines)
let dataParts = inputFileData.components(separatedBy:"\n\n")
let patterns = dataParts[0].split(separator: ", ")
let designs = dataParts[1].components(separatedBy:.newlines)

func isValid(_ design: Substring) -> Bool {
    for pattern in patterns {
        if design.hasPrefix(pattern) {
            if design == pattern {
                return true
            }
            if isValid(design.dropFirst(pattern.count)) {
                return true
            }
        }
    }
    return false
}

let result1 = designs.reduce(0) { $0 + (isValid(Substring($1)) ? 1 : 0)}
print("Day_19_1:",result1)
var cache: [Substring: Int]  = [:]
func countValid(_ design: Substring) -> Int {
    if let count = cache[design] {
        return count
    }
    var sum = 0
    for pattern in patterns {
        if design.hasPrefix(pattern) {
            if design == pattern {
                sum += 1
            } else {
                sum += countValid(design.dropFirst(pattern.count))
            }
        }
    }
    cache[design] = sum
    return sum
}

let result2 = designs.reduce(0) { $0 + countValid(Substring($1))}
print("Day_19_2:",result2)
