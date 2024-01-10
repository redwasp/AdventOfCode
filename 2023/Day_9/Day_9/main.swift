//
//  main.swift
//  Day_9
//
//  Created by Pavlo Liashenko on 09.12.2023.
//

import Foundation

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL).trimmingCharacters(in: .whitespacesAndNewlines)
var report = inputFileData.components(separatedBy:.newlines).map{$0.components(separatedBy:.whitespaces).map{Int($0)!}}

var sum = 0
for line in report {
    sum += nextValue(for: line)
}
print("Day_9_1: \(sum)")

sum = 0
for line in report {
    sum += prevValue(for: line)
}
print("Day_9_2: \(sum)")

func nextValue(for array: [Int]) -> Int {
    let set = Set(array)
    guard set.count > 1 else {return set.first!}
    var newArray : [Int] = []
    for index in 1..<array.count {
        newArray.append(array[index] - array[index-1])
    }
    return array.last! + nextValue(for: newArray)
}

func prevValue(for array: [Int]) -> Int {
    let set = Set(array)
    guard set.count > 1 else {return set.first!}
    var newArray : [Int] = []
    for index in 1..<array.count {
        newArray.append(array[index] - array[index-1])
    }
    return array.first! - prevValue(for: newArray)
}
