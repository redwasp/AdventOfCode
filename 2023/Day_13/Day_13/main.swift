//
//  main.swift
//  Day_13
//
//  Created by Pavlo Liashenko on 13.12.2023.
//

import Foundation
import AdventOfCodeStarterPack

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL).trimmingCharacters(in: .whitespacesAndNewlines)
var patterns = inputFileData.components(separatedBy:"\n\n").map{$0.components(separatedBy:.newlines).map{$0.map{$0 == "#"}}}

func reflectionLine(_ field: [[Bool]])-> Int {
    var valid = true
    for index in 0..<field.count-1 {
        valid = true
        let half = min(index+1, field.count-index-1)
        for offset in 0..<half {
            guard field[index-offset] == field[index+offset+1] else {
                valid = false
                break
            }
        }
        if valid {
            return index + 1
        }
    }

    return 0
}

//Part II
func reflectionLine2(_ field: [[Bool]])-> Int {
    for row1 in 0..<field.count-1 {
        for row2 in row1+1..<field.count {
            var difference = 0
            var dColumn = -1
            for column in 0..<field[row1].count {
                if field[row1][column] != field[row2][column] {
                    difference += 1
                    guard difference == 1 else {break}
                    dColumn = column
                }
            }
            guard difference == 1 else {continue}
            var field = field
            field[row1][dColumn] = !field[row1][dColumn]
            var valid = true
            let line = (row2 + row1 + 1)/2
            var row1 = line - 1
            var row2 = line
            while row1 >= 0 && row2 < field.count {
                guard field[row1] == field[row2] else {
                    valid = false
                    break
                }
                row1 -= 1
                row2 += 1
            }
            if valid {
                return line
            }
        }
    }
    return 0
}

func result(_ reflectionLine: (_ field: [[Bool]])-> Int) -> Int {
    var horizontal = 0
    var vertical = 0
    for pattern in patterns {
        horizontal += reflectionLine(pattern)
        vertical   += reflectionLine(pattern.rotated)
    }
    return horizontal * 100 + vertical
}

print("Day_13_1: \(result(reflectionLine))")//32371
print("Day_13_2: \(result(reflectionLine2))")//37416
