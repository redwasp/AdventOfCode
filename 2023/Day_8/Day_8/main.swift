//
//  main.swift
//  Day_8
//
//  Created by Pavlo Liashenko on 08.12.2023.
//

import Foundation
import AdventOfCodeStarterPack

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL)
                        .trimmingCharacters(in: .whitespacesAndNewlines)
let parts = inputFileData
    .components(separatedBy:"\n\n")
let path = parts[0].map{$0 == "L" ? 0 : 1}
let tree = parts[1].components(separatedBy: .newlines).reduce(into:[String: [String]]()) {
    let parts = $1.components(separatedBy:" = ")
    let key = parts[0]
    let value = parts[1].trimmingCharacters(in: CharacterSet(charactersIn: "()")).components(separatedBy:", ")
    $0[key] = value
}
var key = "AAA"
var index = 0
while key != "ZZZ" {
    let instruction = path[index%path.count]
    key = tree[key]![instruction]
    index += 1
}
print("Day_8_1: \(index)")//21251

let keys = tree.keys.filter{
    $0.last == "A"
}
var result = 1
for key in keys {
    var key = key
    var index = 0
    while key.last != "Z" {
        let instruction = path[index%path.count]
        key = tree[key]![instruction]
        index += 1
    }
    result = lcm(result, index)
}
print("Day_8_2: \(result)")//11678319315857
