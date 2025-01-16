//
//  main.swift
//  Day_11
//
//  Created by Pavlo Liashenko on 11.12.2024.
//

import Foundation

let inputFileURL  = URL(fileURLWithPath: "input1.txt")
let inputFileData = try! String(contentsOf: inputFileURL, encoding: .utf8).trimmingCharacters(in: .whitespacesAndNewlines)
var stones = inputFileData.components(separatedBy:.whitespaces).map{Int($0)!}

var cache : [Int : [Int: Int]] = [:]

print("Day_11_1:", stonesCount(25))
print("Day_11_2:", stonesCount(75))


func stonesCount(_ blinks :Int) -> Int {
    stones.reduce(0) {
        $0 + findNumbers($1, blinks)
    }
}

func findNumbers(_ stone: Int, _ blinks: Int) -> Int {
    guard blinks > 0 else {return 1}
    if let value = cache[stone]?[blinks] {
        return value
    }
    var count = 0
    if stone == 0 {
        count = findNumbers(1, blinks - 1)
    } else {
        var a = stone
        var numbers: [Int] = []
        while a > 0 {
            let x = a.quotientAndRemainder(dividingBy: 10)
            numbers.append(x.remainder)
            a = x.quotient
        }
        if numbers.count % 2 == 0 {
            numbers = numbers.reversed()
            count = findNumbers(numbers[0..<numbers.count/2].reduce(0, {$0*10+$1}), blinks - 1) + findNumbers(numbers[numbers.count/2..<numbers.count].reduce(0, {$0*10+$1}), blinks - 1)
        } else {
            count =  findNumbers(stone*2024, blinks - 1)
        }
    }
    cache[stone, default: [:]][blinks] = count
    return count
}
