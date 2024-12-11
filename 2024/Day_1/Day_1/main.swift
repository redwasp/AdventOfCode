//
//  main.swift
//  Day_1
//
//  Created by Pavlo Liashenko on 02.12.2024.
//

import Foundation

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL, encoding: .utf8).trimmingCharacters(in: .whitespacesAndNewlines)
var data = inputFileData
    .components(separatedBy:.newlines)
    .map {
        $0
        .split(separator:" ", omittingEmptySubsequences: true)
        .map{Int($0)!}
    }
let left = data.map{$0[0]}.sorted()
let right = data.map{$0[1]}.sorted()
var result1 = 0
for index in left.indices {
    result1 += abs(left[index]-right[index])
}
print("Day_1_1:",result1)

let map = right.reduce(into: [Int:Int]()) { $0[$1, default: 0] += 1}
var result2 = 0
for left in left {
    result2 += left*map[left, default: 0]
}
print("Day_1_2:",result2)
