//
//  main.swift
//  Day_1
//
//  Created by Pavlo Liashenko on 23.03.2024.
//

import Foundation

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL).trimmingCharacters(in: .whitespacesAndNewlines)
let lines = inputFileData.split(separator: "\n" )
let numbers = lines.map{Int($0)!}
var result = 0
var index = 0
var set: Set<Int> = []
repeat {
    set.insert(result)
    result += numbers[index]
    index += 1
} while index < lines.count
print("Day_1_1: \(result)")//445

index = 0
repeat {
    set.insert(result)
    result += numbers[index]
    index += 1
    if index >= lines.count {
        index = 0
    }
} while !set.contains(result)

print("Day_1_2: \(result)")//219
