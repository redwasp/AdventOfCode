//
//  main.swift
//  Day_2
//
//  Created by Pavlo Liashenko on 02.12.2024.
//

import Foundation

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL, encoding: .utf8).trimmingCharacters(in: .whitespacesAndNewlines)
var reports = inputFileData
    .components(separatedBy:.newlines)
    .map {
        $0.split(separator:" ", omittingEmptySubsequences: true).map{Int($0)!}
    }
    .map {
        var (a, b) = (0, 0)
        for index in 1..<$0.count {
            if $0[index-1] > $0[index] {
                a += 1
            } else if $0[index-1] < $0[index] {
                b += 1
            }
        }
        return  a > b ? $0.reversed() : $0
    }

var result1 = reports.reduce(0) { $0 + (isValid($1) ? 1 : 0)}
print("Day_2_1:", result1)//257

var result2 = reports.reduce(0) { $0 + (isToleranceValid($1) ? 1 : 0)}
print("Day_2_2:", result2)//328


func isValid(_ arr: [Int]) -> Bool {
    var prev = arr.first!
    for index in 1..<arr.count {
        let x = arr[index] - prev
        if x < 1 || x > 3 {
            return false
        }
        prev = arr[index]
    }
    return true
}

func isToleranceValid(_ ar: [Int]) -> Bool {
    for toRemove in 0..<ar.count {
        var arr = ar
        arr.remove(at: toRemove)
        if isValid(arr) {
            return true
        }
    }
    return false
}
