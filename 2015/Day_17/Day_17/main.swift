//
//  main.swift
//  Day_17
//
//  Created by Pavlo Liashenko on 09.06.2022.
//

import Foundation

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL)
let lines = inputFileData.split(separator: "\n", omittingEmptySubsequences: true)
let containers = Array(lines.map{Int($0)!}.sorted().reversed())

let max = 150
var count = 0
var min = Int.max
var minCount = 0

func find(_ sum: Int = 0, _ offset: Int = 0, _ size: Int = 0) {
    if sum < max {
        for index in offset..<containers.count {
            find(sum + containers[index], index + 1, size + 1)
        }
    } else if sum == max {
        count += 1
        if size < min {
            minCount = 1
            min = size
        } else if size == min {
            minCount += 1
        }
    }
}
find()
print("Day_17_1: \(count)")//1304
print("Day_17_2: \(minCount)")//18
