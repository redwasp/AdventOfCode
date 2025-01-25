//
//  main.swift
//  Day_9
//
//  Created by Pavlo Liashenko on 13.12.2022.
//

import Foundation
import AdventOfCodeStarterPack

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL).trimmingCharacters(in: .whitespacesAndNewlines)
var steps = inputFileData.components(separatedBy:"\n").map{Step($0)}

struct Step {
    let direction: Position
    let count: Int
    
    init(_ step: String) {
        let parts = step.components(separatedBy: .whitespaces)
        self.direction = Direction(parts[0].first!)!
        self.count = Int(parts[1])!
    }
}

func next(_ chain: Position, _ delta: Position) -> Position {
    var chain = chain
    if delta.x > 1 {
        chain.x += 1
        if delta.y > 0 {
            chain.y += 1
        } else if delta.y < 0 {
            chain.y -= 1
        }
    } else if delta.x < -1 {
        chain.x -= 1
        if delta.y > 0 {
            chain.y += 1
        } else if delta.y < 0 {
            chain.y -= 1
        }
    } else
    if delta.y > 1 {
        chain.y += 1
        if delta.x > 0 {
            chain.x += 1
        } else if delta.x < 0 {
            chain.x -= 1
        }
    } else if delta.y < -1 {
        chain.y -= 1
        if delta.x > 0 {
            chain.x += 1
        } else if delta.x < 0 {
            chain.x -= 1
        }
    }
    return chain
}

func process(_ length: Int) -> Int {
    var rope: [Position] = Array(repeating: .zero, count:length)
    var tails: Set<Position> = [rope.last!]

    for step in steps {
        let offset = step.direction
        for _ in 0..<step.count {
            rope[0] += offset
            for i in 1..<length {
                rope[i] = next(rope[i], rope[i-1] - rope[i])
            }
            tails.insert(rope.last!)
        }
    }
    return tails.count
}

print("Day9_1: \(process(2))")
print("Day9_2: \(process(10))")
