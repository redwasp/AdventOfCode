//
//  main.swift
//  Day_1_1
//
//  Created by Pavlo Liashenko on 01.12.2021.
//

import Foundation

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL)
let numbers = inputFileData.components(separatedBy: .newlines).compactMap{Int($0)}

var prev = numbers[0]
var count = 0
for index in 1..<numbers.count {
    let number = numbers[index]
    if number > prev {
        count += 1
    }
    prev = number
}
print("Day_1_1: \(count)")//1832

count = 0
prev = 0
let size = 3
for i in 0...numbers.count-size {
    let sum = numbers[i..<i+size].reduce(0, +)
    if prev != 0 && sum > prev {
        count += 1
    }
    prev = sum
}
print("Day_1_2: \(count)")//1858
