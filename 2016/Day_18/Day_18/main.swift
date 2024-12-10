//
//  main.swift
//  Day_18
//
//  Created by Pavlo Liashenko on 22.08.2022.
//

import Foundation

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL)
var input = inputFileData.trimmingCharacters(in: .whitespacesAndNewlines)
let firstRow = input.map{$0 == "." ? true : false}
var rowsCount1 = 40
var rowsCount2 = 400000

var prevRow = firstRow
var count = firstRow.reduce(into: 0) {$0 += $1 ? 1 : 0}

for index in 1..<rowsCount2 {
    var row : [Bool] = []
    for col in 0..<firstRow.count {
        let left   = col > 0 ? prevRow[col-1] : true
        let center = prevRow[col]
        let right  = col < prevRow.count-1 ? prevRow[col+1] : true
        let item = !((left && center && !right) || (!left && center && right) || (!left && !center && right) || (left && !center && !right))
        count += item ? 1 : 0
        row.append(item)
    }
    if index == rowsCount1-1 {
        print("Day_18_1: \(count)")
    }
    prevRow = row
}

print("Day_18_2: \(count)")//1982



