//
//  main.swift
//  Day_6
//
//  Created by Pavlo Liashenko on 01.08.2022.
//

import Foundation

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL)
var lines = inputFileData.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines)

var map : [[Character: Int]] = Array(repeating: [Character: Int](), count: lines[0].count)
for line in lines {
    for (index, char) in line.enumerated() {
        map[index][char, default:0] += 1
    }
}

var code = ""
for column in map {
    code.append(column.max{ $0.value < $1.value}!.key)
}

print("Day6_1:\(code)")

code = ""
for column in map {
    code.append(column.max{ $0.value > $1.value}!.key)
}
print("Day6_2:\(code)")
