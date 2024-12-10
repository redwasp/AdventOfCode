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
        $0.split(separator:" ", omittingEmptySubsequences: true).map{Int($0)!}
    }
let a = data.map{$0[0]}.sorted()
let b = data.map{$0[1]}.sorted()
var result1 = 0
for index in a.indices {
    result1 += abs(a[index]-b[index])
}
print(result1)
let map = b.reduce(into: [Int:Int]()) { $0[$1, default: 0] += 1}
var result2 = 0
for left in a {
    result2 += left*map[left, default: 0]
}
print(result2)

