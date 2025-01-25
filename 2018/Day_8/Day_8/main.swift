//
//  main.swift
//  Day_8
//
//  Created by Pavlo Liashenko on 17.01.2023.
//

import Foundation

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL).trimmingCharacters(in: .whitespacesAndNewlines)
let numbers = inputFileData.components(separatedBy:.whitespaces).map{Int($0)!}
func process(_ n: inout [Int]) -> Int {
    guard n.count != 0 else {return 0}
    let childCount = n.removeFirst()
    let metaSize   = n.removeFirst()
    var res = 0
    for _ in 0..<childCount {
        res += process(&n)
    }
    let metaData = n.prefix(metaSize)
    n.removeSubrange(0..<metaSize)
    res += metaData.reduce(0,+)
    return res
}

func process2(_ n: inout [Int]) -> Int {
    guard n.count != 0 else {return 0}
    let childCount = n.removeFirst()
    let metaSize   = n.removeFirst()
    var res = 0
    var childs : [Int] = []
    for _ in 0..<childCount {
        childs.append(process2(&n))
    }
    let metaData = n.prefix(metaSize)
    n.removeSubrange(0..<metaSize)
    if childCount == 0 {
        res += metaData.reduce(0,+)
    } else {
        for index in metaData {
            guard index <= childCount else {continue}
            res += childs[index-1]
        }
    }

    return res
}


var nx = numbers
print("Day_8_1: \(process(&nx))")

nx = numbers
print("Day_8_2: \(process2(&nx))")
