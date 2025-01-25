//
//  main.swift
//  Day_25
//
//  Created by Pavlo Liashenko on 04.01.2023.
//

import Foundation

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL).trimmingCharacters(in: .newlines)
var blocks = inputFileData.components(separatedBy:"\n\n").map{$0.components(separatedBy: .newlines).map{$0.trimmingCharacters(in: .punctuationCharacters)}}

let states = ["A": 0, "B": 1, "C": 2, "D": 3, "E": 4, "F": 5]
let offsets = ["right": 1, "left": -1]

var start = blocks.removeFirst()
let startState = start[0].components(separatedBy:.whitespaces).last!
let startStateIndex = states[startState]!
var steps = Int(start[1].components(separatedBy:.whitespaces).dropLast().last!)!
var commands : [[[Int]]] = Array(repeating: [], count: 6)

for block in blocks {
    let a = block.map{$0.components(separatedBy: .whitespaces).last!}
    commands[states[a[0]]!] = [[Int(a[2])!, offsets[a[3]]!, states[a[4]]!], [Int(a[6])!, offsets[a[7]]!, states[a[8]]!]]
}

var size = 10000
var offset = size/2
var field : [Int] = Array(repeating: 0, count: size)
var marker = 0
var nextCommand = startStateIndex
for _ in 0..<steps {
    let fm = offset + marker
    let command = commands[nextCommand][field[fm]]
    field[fm] = command[0]
    marker += command[1]
    nextCommand = command[2]
}
var checksum = field.reduce(0, +)
print("Day_25_1: \(checksum)")
