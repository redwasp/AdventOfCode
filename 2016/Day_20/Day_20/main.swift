//
//  main.swift
//  Day_20
//
//  Created by Pavlo Liashenko on 27.08.2022.
//

import Foundation

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL)
var ranges = inputFileData.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines).map{$0.split(separator:"-").map{Int($0)!}}.sorted{$0[0] < $1[0]}

var last = 0
var pos = 0
while last+1 >= ranges[pos][0] {
    if ranges[pos][1] > last {
        last = ranges[pos][1]
    }
    pos += 1
}
print("Day_20_1: \(last+1)")

var count = 4294967295 + 1
var depoMin = 0
var depoMax = 0
for range in ranges {
    if range[0] <= depoMax {
        if range[1] > depoMax {
            depoMax = range[1]
        }
    } else {
        count -= depoMax - depoMin + 1
        depoMin = range[0]
        depoMax = range[1]
    }
}
count -= depoMax - depoMin + 1
print("Day_20_2: \(count)")
