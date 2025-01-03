//
//  main.swift
//  Day_18
//
//  Created by Pavlo Liashenko on 18.12.2024.
//

import Foundation
import AdventOfCodeStarterPack

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL, encoding: .utf8).trimmingCharacters(in: .whitespacesAndNewlines)
let bytes = inputFileData.components(separatedBy: .newlines).map{$0.split(separator:",").map{Int($0)!}}.map{Position($0[0], $0[1])}
let (size, count) = (70, 1024)

var field = Array(repeating: Array(repeating: 0, count: size+1), count: size+1)

bytes[0..<count].forEach {field[$0] = -1}

let start = Position.zero
let end   = Position(size, size)
var positions: [Position] = [start]
var step = 1
exit: while positions.count != 0 {
    var newPositions: [Position] = []
    for pos in positions {
        for dir in Directions.downRight {
            let newPos = pos + dir
            if field.valid(position: newPos),
               field[newPos] == 0 {
               field[newPos] = step
                newPositions.append(newPos)
                if newPos == end {
                    break exit
                }
            }
        }
    }
    positions = newPositions
    step += 1
}

print("Day_18_1:", step)

func printField() {
    var str = ""
    for line in field {
        for char in line {
            switch char {
            case -1: str += "#"
            case  0: str += "."
            default: str += "+"
            }
        }
        str += "\n"
    }
    print(str)
}

Exit: for ss in count..<bytes.count {
    var field = Array(repeating: Array(repeating: 0, count: size+1), count: size+1)
    bytes[0..<ss].forEach { field[$0] = -1}
    let start = Position.zero
    let end   = Position(size, size)
    var positions: [Position] = [start]
    var step = 1
    exit: while positions.count != 0 {
        var newPositions: [Position] = []
        for pos in positions {
            for dir in Directions.downRight {
                let newPos = pos + dir
                if field.valid(position: newPos),
                   field[newPos] == 0 {
                   field[newPos] = step
                    newPositions.append(newPos)
                    if newPos == end {
                        break exit
                    }
                }
            }
        }
        positions = newPositions
        if (positions.count == 0) {
            print("Day_18_2: \(bytes[ss-1].x),\(bytes[ss-1].y)")
            break Exit
        }
        step += 1
    }
}
