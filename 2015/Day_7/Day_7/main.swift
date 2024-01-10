//
//  main.swift
//  Day_7
//
//  Created by Pavlo Liashenko on 25.05.2022.
//

import Foundation

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL)
let lines = inputFileData.split(separator: "\n", omittingEmptySubsequences: true)
var tree = lines.map{$0.components(separatedBy:" -> ").map{$0.components(separatedBy:.whitespaces)}}.reduce(into: [String: [String]]()) {
    $0[$1[1][0]]=$1[0]
}
var regs : [String: UInt16] = [:]

func find(_ node: String) -> UInt16 {
    var result = UInt16(node) ?? regs[node]
    if result == nil {
        let item = tree[node]!
        if item.count == 1 {
            result = find(item[0])
        } else if item.count == 2 {
            result = ~find(item[1])
        } else if item.count == 3 {
            let arg1 = find(item[0])
            let arg2 = find(item[2])
            switch item[1] {
            case "AND":
                result = arg1 & arg2
            case "OR":
                result = arg1 | arg2
            case "RSHIFT":
                result = arg1 >> arg2
            case "LSHIFT":
                result = arg1 << arg2
            default:
                break
            }
        }
        regs[node] = result
    }
    return result!
}
let a1 = find("a")
print("Day_7_1: \(a1)")

regs.removeAll()
tree["b"] = ["\(a1)"]

let a2 = find("a")
print("Day_7_2: \(a2)")
