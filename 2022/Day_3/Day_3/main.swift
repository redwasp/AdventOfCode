//
//  main.swift
//  Day_3
//
//  Created by Pavlo Liashenko on 04.12.2022.
//

import Foundation

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL).trimmingCharacters(in: .whitespacesAndNewlines)
let lines = inputFileData.components(separatedBy:"\n")
var codes = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ".enumerated().reduce(into: [Character: Int]()) {
    $0[$1.element] = $1.offset + 1
}

var result = 0
for line in lines {
    let halfIndex = line.index(line.startIndex, offsetBy: line.count/2)
    let left  = Set(line[..<halfIndex])
    let rigght = Set(line[halfIndex...])
    result += codes[left.intersection(rigght).first!]!
}
print("Day_3_1: \(result)")

result = 0

for index in 0..<lines.count/3 {
    let offset = index*3
    let set  = Set(lines[offset]).intersection(Set(lines[offset+1]).intersection(Set(lines[offset+2])))
    result += codes[set.first!]!
}

print("Day_3_2: \(result)")
