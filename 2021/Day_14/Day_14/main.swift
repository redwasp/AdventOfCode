//
//  main.swift
//  Day_14
//
//  Created by Pavlo Liashenko on 14.12.2021.
//

import Foundation

let inputFileURL  = URL(fileURLWithPath: "input1.txt")
let inputFileData = try! String(contentsOf: inputFileURL).trimmingCharacters(in: .whitespacesAndNewlines)
var parts = inputFileData.components(separatedBy:"\n\n")
var template = parts[0].map{$0.asciiValue!}
var rf : [[UInt8]] = Array(repeating: Array(repeating: 0, count: 256), count: 256)
let rules = parts[1].components(separatedBy: .newlines).map{$0.components(separatedBy: " -> ").map{$0.map{$0.asciiValue!}}}
for item in rules {
    rf[Int(item[0][0])][Int(item[0][1])] = item[1][0]
}

var chashe : [[[[UInt8:Int]]]] = Array(repeating: Array(repeating:  Array(repeating: [:], count: 256), count: 256), count: 256)
func rec(_ step: UInt8, _ a: UInt8, _ b: UInt8) -> [UInt8 : Int] {
    var res = chashe[Int(step)][Int(a)][Int(b)]
    guard res.isEmpty else {return res}
    let c = rf[Int(a)][Int(b)]
    if step == 0 {
        if a != b {
            res = [a : 1, b : 1]
        } else {
            res = [a : 2]
        }
    } else {
        let ac = rec(step-1, a, c)
        let ab = rec(step-1, c, b)
        res = ac.merging(ab) {$0 + $1}
        res[c]! -= 1
    }
    chashe[Int(step)][Int(a)][Int(b)] = res
    return res
}

func clac(_ steps: UInt8, _ polymer: [UInt8]) -> Int {
    var result : [UInt8 : Int] = [:]
    for index in 0..<polymer.count-1 {
        let r = rec(steps, polymer[index], polymer[index+1])
        result.merge(r) {$0+$1}
        if index != 0 {
            result[polymer[index]]! -= 1
        }
    }
    return result.values.max()! - result.values.min()!
}

print("Day_14_1:\(clac(10, template))")
print("Day_14_2:\(clac(40, template))")
