//
//  main.swift
//  Day_8
//
//  Created by Pavlo Liashenko on 13.09.2022.
//

import Foundation

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL)
var lines = inputFileData.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines)
var regs : [String : Int] = [:]
var max = 0
for line in lines {
    let words = line.split(separator:" ")
    let reg = String(words[0])
    if regs[reg] == nil {
        regs[reg] = 0
    }
    let testReg = String(words[4])
    let testRegValue = regs[testReg] ?? 0
    let testValue = Int(words[6])!
    var testRes = false
    switch words[5] {
    case ">": testRes = testRegValue > testValue
    case "<": testRes = testRegValue < testValue
    case "<=": testRes = testRegValue <= testValue
    case ">=": testRes = testRegValue >= testValue
    case "==": testRes = testRegValue == testValue
    case "!=": testRes = testRegValue != testValue
    default: testRes = false
    }
    if (testRes) {
        let regValue = regs[reg] ?? 0
        let valueStr = words[2]
        let value = Int(valueStr)!
        let command = words[1]
        switch command {
            case "inc": regs[reg] = regValue + value
            case "dec": regs[reg] = regValue - value
        default: break
        }
    }
    if max < regs[reg]! {
        max = regs[reg]!
    }
}

print("Day_8_1: \(regs.values.max()!)")
print("Day_8_2: \(max)")
