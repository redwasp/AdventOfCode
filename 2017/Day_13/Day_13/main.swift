//
//  main.swift
//  Day_13
//
//  Created by Pavlo Liashenko on 14.09.2022.
//

import Foundation

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL)
var input = inputFileData.trimmingCharacters(in: .whitespacesAndNewlines)
let lines = input.split(separator: "\n")
var layersM: [[Int]] = []
for line in lines {
    let numbers = line.split(separator: ":").map { Int($0.trimmingCharacters(in: .whitespaces))!}
    layersM.append(numbers)
}
let layers = layersM
var severity = 0
for layer in layers {
    if layer[0]%(layer[1]*2-2) == 0 {
        severity += layer[0]*layer[1]
    }
}
print("severity = \(severity)")


var offset = -1
var valid = false
repeat {
    offset += 1
    valid = true
    for layer in layers {
        let mod = (offset+layer[0])%(layer[1]*2-2)
        if (mod == 0) {
            valid = false
            break
        }
    }
} while !valid
print("offset = \(offset)")
