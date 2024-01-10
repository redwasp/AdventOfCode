//
//  main.swift
//  Day_2
//
//  Created by Pavlo Liashenko on 02.12.2021.
//

import Foundation

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL)
var dataLines = inputFileData.split(separator:"\n" , omittingEmptySubsequences: true)
let components = dataLines.compactMap{$0.components(separatedBy:" ")}

enum Command : String {
    case forward
    case up
    case down
}
let items = components.map { (command: Command(rawValue: $0[0])!, value: Int($0[1])!)}

struct Position {
    var horizontal : Int = 0
    var depth : Int = 0
}

var position = Position()

for item in items {
    switch item.command {
    case .forward:
        position.horizontal += item.value
    case .down:
        position.depth += item.value
    case .up:
        position.depth -= item.value
    }
}

print("Day_2_1: \(position.horizontal*position.depth)")

var aim = 0
position = Position()

for item in items {
    switch item.command {
    case .forward:
        position.horizontal += item.value
        position.depth += aim*item.value
    case .down:
        aim += item.value
    case .up:
        aim -= item.value
    }
}
print("Day_2_2: \(position.horizontal*position.depth)")
