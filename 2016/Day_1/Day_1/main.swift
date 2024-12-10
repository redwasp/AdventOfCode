//
//  main.swift
//  Day_1
//
//  Created by Pavlo Liashenko on 18.07.2022.
//

import Foundation
import AdventOfCodeStarterPack

struct Step {
    enum Rotate : Int {
        case left = -1
        case right = 1
    }
    let rotate: Rotate
    let length: Int
    init(_ string: String) {
        self.rotate = string.prefix(1) == "R" ? .right : .left
        self.length = Int(string.suffix(from:string.index(after:string.startIndex)))!
    }
}

let directions: Directions =  [.down, .right, .up, .left]

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL)
let steps = inputFileData
    .trimmingCharacters(in: .whitespacesAndNewlines)
    .components(separatedBy:", ")
    .map {
        Step($0)
    }

var directionIndex = 0
var position: Position = .zero
for step in steps {
    directionIndex = (directionIndex + step.rotate.rawValue) %% (directions.count)
    let direction = directions[directionIndex]
    position += direction*step.length
}
print("Day_1_1: \(position.distance(to: .zero))")//287

let offset = Position(200, 200)
var field : [[Bool]] = Array(repeating: Array(repeating: false, count: offset.x*2), count: offset.y*2)
position = offset
exit: for step in steps {
    directionIndex = (directionIndex + step.rotate.rawValue) %% directions.count
    let direction = directions[directionIndex]

    for _ in 0 ..< step.length {
        position += direction
        if !field[position] {
            field[position] = true
        } else {
            break exit
        }
    }
}

print("Day_1_2: \(position.distance(to: offset))")//133
