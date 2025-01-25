//
//  main.swift
//  Day_2
//
//  Created by Pavlo Liashenko on 09.09.2022.
//

import Foundation

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL)
var lines = inputFileData.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy:.newlines).map{$0.components(separatedBy:.whitespaces).map{Int($0)!}}
var sum = 0
for line in lines {
    sum += line.max()! - line.min()!
}
print("Day_2_1:\(sum)")

var checksum = 0
for line in lines {
    for i in 0..<lines.count {
        for j in i+1..<lines[i].count {
            let maxValue = max(line[i],line[j])
            let minValue = min(line[i],line[j])
            if maxValue%minValue == 0 {
                checksum += maxValue/minValue
            }
        }
    }
}
print("Day_2_2:\(checksum)")
