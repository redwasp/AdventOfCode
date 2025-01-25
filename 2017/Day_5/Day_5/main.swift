//
//  main.swift
//  Day_5
//
//  Created by Pavlo Liashenko on 10.09.2022.
//

import Foundation

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL)
let numbers = inputFileData.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy:.newlines).map{Int($0)!}

func process(_ numbers: [Int], part: Int) -> Int  {
    var numbers = numbers
    var exit = false
    var steps  = 0
    var position = 0
    while !exit {
        if (position >= numbers.count) {
            exit = true
            break
        }
        let value = numbers[position]
        numbers[position] += part == 1 ? 1 : (value >= 3 ? -1 : 1)
        position = position + value
        if (position < 0) {
            print("\(position)")
        }
        steps += 1
    }
    return steps
}

print("Day_5_1: \(process(numbers, part:1))")
print("Day_5_2: \(process(numbers, part:2))")
