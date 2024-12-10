//
//  main.swift
//  Day_3
//
//  Created by Pavlo Liashenko on 03.12.2024.
//

import Foundation

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let iFD = try! String(contentsOf: inputFileURL, encoding: .utf8).trimmingCharacters(in: .whitespacesAndNewlines)
let digits = /mul\([0-9]+,[0-9]+\)/
let result = iFD.matches(of: digits)
    .map {
        iFD[iFD.index($0.range.lowerBound, offsetBy:4)..<iFD.index(before: $0.range.upperBound)]
            .components(separatedBy:",")
            .map{Int($0)!}
            .reduce(1, *)
    }
    .reduce(0, +)
print("Day_3_1:",result)//156388521

let digits2 = /(mul\([0-9]+,[0-9]+\))|(do\(\))|(don't\(\))/
let instructions = iFD.matches(of: digits2).map{iFD[$0.range]}
var isDO = true
let result2 = iFD
    .matches(of: digits2)
    .map {
        if iFD[$0.range] == "don't()" {
            isDO = false
        } else if iFD[$0.range] == "do()" {
            isDO = true
        } else {
            if isDO {
                return iFD[iFD.index($0.range.lowerBound, offsetBy:4)..<iFD.index(before: $0.range.upperBound)]
                    .components(separatedBy:",")
                    .map{Int($0)!}
                    .reduce(1, *)
            }
        }
        return 0
    }
    .reduce(0, +)
print("Day_3_2:", result2)
