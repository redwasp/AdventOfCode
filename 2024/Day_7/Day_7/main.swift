//
//  main.swift
//  Day_7
//
//  Created by Pavlo Liashenko on 07.12.2024.
//

import Foundation

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL, encoding: .utf8).trimmingCharacters(in: .whitespacesAndNewlines)
var lines = inputFileData.components(separatedBy:.newlines)
var resul1 = 0
var resul2 = 0
for line in lines {
    let parts = line.components(separatedBy: ":")
    let y = Int(parts[0])!
    let args = parts[1].split(separator:" ", omittingEmptySubsequences: true).map{Int($0)!}
    if isValid(y, args) {
        resul1 += y
    }
    if isValid2(y, args) {
        resul2 += y
    }
}
print("Day_7_1:",resul1)
print("Day_7_2:",resul2)

func isValid(_ target: Int,_ args: [Int]) -> Bool {
    var values: Set<Int> = [args[0]]
    var (a, b) = (0, 0)
    for arg in args[1...] {
        var newValues: Set<Int> = []
        for value in values {
            a = value + arg
            if a <= target {
                newValues.insert(a)
            }
            b = value * arg
            if b <= target {
                newValues.insert(b)
            }
        }
        values = newValues
    }
    return values.contains(target)
}


func isValid2(_ target: Int,_ args: [Int]) -> Bool {
    var values: Set<Int> = [args[0]]
    var (a, b, c) = (0, 0, 0)
    for arg in args[1...] {
        var newValues: Set<Int> = []
        var argSize = 1
        a = arg
        while a != 0 {
            argSize *= 10
            a /= 10
        }
        for value in values {
            a = value + arg
            if a <= target {
                newValues.insert(a)
            }
            b = value * arg
            if b <= target {
                newValues.insert(b)
            }
            
            b = value * arg
            if b <= target {
                newValues.insert(b)
            }
            c = value * argSize + arg
            if c <= target {
                newValues.insert(c)
            }
        }
        values = newValues
    }
    return values.contains(target)
}
