//
//  main.swift
//  Day_4
//
//  Created by Pavlo Liashenko on 04.12.2022.
//

import Foundation

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL).trimmingCharacters(in: .whitespacesAndNewlines)
let lines = inputFileData.components(separatedBy:"\n")
let ranges = lines
            .map {
                $0.split(separator:",")
                    .map {
                        $0.components(separatedBy:"-")
                          .map {
                              Int($0)!
                          }
                    }
                    .map {
                        $0[0]...$0[1]
                    }
            }

var count1 = 0
var count2 = 0
for pair in ranges {
    if (pair[0].lowerBound >= pair[1].lowerBound && pair[0].upperBound <= pair[1].upperBound) || (pair[0].lowerBound <= pair[1].lowerBound && pair[0].upperBound >= pair[1].upperBound) {
        count1 += 1
        count2 += 1
    } else if pair[0].overlaps(pair[1]) {
        count2 += 1
    }
    
}

print("Day_4_1: \(count1)")
print("Day_4_1: \(count2)")
