//
//  main.swift
//  Day_14
//
//  Created by Pavlo Liashenko on 14.12.2024.
//

import Foundation
import AdventOfCodeStarterPack

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL, encoding: .utf8).trimmingCharacters(in: .whitespacesAndNewlines)
let robots = inputFileData
    .split(separator:"\n")
    .map {
        $0
        .split(separator:" ")
        .map {
            $0
            .split(separator:"=")[1]
            .split(separator:",")
            .map{Int($0)!}
        }
        .map{
            Position($0[0], $0[1])
        }
    }

let size = Position(101, 103)
let half = Position(size.x/2, size.y/2)

var sq = [0,0,0,0]
for robot in robots {
    var pos = robot[0]
    pos += robot[1]*100
    pos %%= size
    if pos.x < half.x {
        if pos.y < half.y {
            sq[0] += 1
        } else if pos.y > half.y {
            sq[1] += 1
        }
    } else if pos.x > half.x {
        if pos.y < size.y/2 {
            sq[2] += 1
        } else if pos.y > half.y {
            sq[3] += 1
        }
    }
}
var result1 = sq.reduce(1, *)
print("Day_14_1:", result1)

var step = 0
var max = 0
exit: while true {
    step += 1
    var set = Set<Position>()
    for robot in robots {
        var pos = robot[0]
        pos += robot[1]*step
        pos %%= size
        set.insert(pos)
    }
    var count = 0
    for pos in set {
        for dir in Directions.clockwise {
            if set.contains(pos + dir) {
                count += 1
            }
        }
    }
    
    
    if count > max {
         max = count
        if (max > robots.count*2) {//???
            var str = ""
            for y in 0...size.y {
                for x in 0...size.x {
                    str += set.contains(Position(x, y)) ? "*" : "."
                }
                str += "\n"
            }
            print("Day_14_2:", step)
            break;
        }
    }
}
