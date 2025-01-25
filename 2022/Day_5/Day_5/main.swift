//
//  main.swift
//  Day_5
//
//  Created by Pavlo Liashenko on 05.12.2022.
//

import Foundation

struct Step {
    let count: Int
    let from: Int
    let to: Int
}

let inputFileURL  = URL(fileURLWithPath: "input2.txt")
let inputFileData = try! String(contentsOf: inputFileURL).trimmingCharacters(in: .newlines)
let parts = inputFileData.components(separatedBy:"\n\n").map{$0.components(separatedBy:"\n")}
var stacksData = parts[0].map{$0.map{$0}}
stacksData.removeLast()
let size = 9
var defaultStacks :  [[Character]] = Array(repeating: [], count: size)
for i in 0..<size {
    let index = i*4 + 1
    for line in stacksData {
        let char = line[index]
        if char.isLetter {
            defaultStacks[i].append(char)
        }
    }
}

var stacks = defaultStacks

var steps = parts[1].map{
   let parts = $0.components(separatedBy:.whitespaces)
    return Step(count: Int(parts[1])!, from: Int(parts[3])! - 1, to: Int(parts[5])! - 1)
}

for step in steps {
    for _ in 0..<step.count {
        let item = stacks[step.from].removeFirst()
        stacks[step.to].insert(item, at: 0)
    }
}
print("Day_5_1: \(String(stacks.map{$0.first!}))")

stacks = defaultStacks
for step in steps {
    let items = stacks[step.from].prefix(step.count)
    stacks[step.from].removeFirst(step.count)
    stacks[step.to].insert(contentsOf: items, at: 0)
}
print("Day_5_2: \(String(stacks.map{$0.first!}))")
