//
//  main.swift
//  Day_2
//
//  Created by Pavlo Liashenko on 02.12.2024.
//

import Foundation

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL, encoding: .utf8).trimmingCharacters(in: .whitespacesAndNewlines)
var result : Int = inputFileData
    .components(separatedBy:.newlines)
    .map {
        $0.split(separator:" ", omittingEmptySubsequences: true).map{Int($0)!}
    }
    .map {
        var e : [Int] = []
        var errors = 0
        var a = 0
        var b = 0
        for index in 1..<$0.count {
            if $0[index-1] > $0[index] {
                a += 1
            } else if $0[index-1] < $0[index] {
                b += 1
            }
        }
        
        var ar = $0
        if a > b {
            ar = $0.reversed()
        }
        return isToleranceValid(ar)
    }
    .reduce(0) { $0 + ($1 ? 1 : 0)}

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


print("Day_2_1: \(result)")//310
