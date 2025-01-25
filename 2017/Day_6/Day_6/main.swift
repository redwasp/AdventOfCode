//
//  main.swift
//  Day_6
//
//  Created by Pavlo Liashenko on 12.09.2022.
//

import Foundation

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL)
var blocks = inputFileData.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .whitespaces).map{Int($0)!}

var history : Set<UInt64> =  Set()
var array : Array<UInt64> =  Array()
var exit = false
var cycles = 0
var loopsize = 0
while !exit {
    cycles += 1
    var value = blocks.max()!
    var valueIndex = blocks.firstIndex(of: value)!
    blocks[valueIndex] = 0
    while value != 0 {
        valueIndex += 1
        if (valueIndex >= blocks.count) {
            valueIndex = 0
        }
        blocks[valueIndex] += 1
        value -= 1
    }
    var i : UInt64 = 0
    for index in 0..<blocks.count {
        i |= UInt64(blocks[index])<<(index*4)
    }

    if history.contains(i) {
        let index = array.firstIndex(of:i)!
        loopsize = cycles - index - 1
        break
    } else {
        history.insert(i)
        array.append(i)
    }
}

print("Day_6_1: \(cycles)")
print("Day_6_2: \(loopsize)")
