//
//  main.swift
//  Day_6
//
//  Created by Pavlo Liashenko on 17.05.2022.
//

import Foundation

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL)
let lines = inputFileData.split(separator: "\n", omittingEmptySubsequences: true)

let vowels : Set<Character>  = Set("aeiou")
let badPairs : Set<String> = Set(["ab", "cd", "pq", "xy"])
var niceStringsCount = 0
for line in lines {
    var vowelsCount = 0
    var pairsCount = 0
    var hasBadPairs = false
    var pair = ""
    for char in line {
        if vowels.contains(char) {
            vowelsCount += 1
        }
        pair.append(char)
        if pair.count > 2 {
            pair.removeFirst()
        }
        if pair.count == 2 && pair.first == pair.last {
            pairsCount += 1
        }
        if badPairs.contains(pair) {
            hasBadPairs = true
            break;
        }
    }
    if vowelsCount >= 3 && pairsCount >= 1 && !hasBadPairs {
        niceStringsCount += 1
    }
}
print("Day5_1: \(niceStringsCount)")

niceStringsCount = 0
for line in lines {
    var hasPairs = false
    var hasPairsX = false
    for index in line.indices {
        let char = line[index]
        var nextIndex = line.index(after: index)
        if !line.indices.contains(nextIndex) {
            break
        }
        let secondChar = line[nextIndex]
        nextIndex = line.index(after: nextIndex)
        if line.indices.contains(nextIndex) && line[nextIndex] == char {
            hasPairs = true
        }
        while nextIndex < line.index(before:line.endIndex) {
            let charX = line[nextIndex]
            nextIndex = line.index(after: nextIndex)
            let secondCharX = line[nextIndex]
            if charX == char && secondChar == secondCharX {
                hasPairsX = true
                break;
            }
        }


    }
    if hasPairs && hasPairsX {
        niceStringsCount += 1
    }
}
print("Day5_2: \(niceStringsCount)")
