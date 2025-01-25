//
//  main.swift
//  Day_11
//
//  Created by Pavlo Liashenko on 19.01.2023.
//

import Foundation


var gsn = 2568
var field : [[Int]] = Array.init(repeating: Array.init(repeating: 0, count: 300), count: 300)
for x in 0..<300 {
    for y in 0..<300 {
        field[y][x] = powerLevel(x: x, y: y, gsn: gsn)
    }
}

var max = 0
var maxX = 0
var maxY = 0
var maxS = 0
var size = 3
for x in 0..<300-size {
    for y in 0..<300-size {
        var sum = 0
        for dx in x..<x+size {
            for dy in y..<y+size {
                sum += field[dy][dx]
            }
        }
        if sum > max {
           max = sum
           maxX = x
           maxY = y
        }
    }
}

print("Day_11_1: (\(maxX+1),\(maxY+1))")

func powerLevel(x : Int, y : Int, gsn : Int) -> Int {
    let x = x + 1
    let y = y + 1
    let rankId = x + 10
    var pl = (y*rankId + gsn)*rankId
    let max = (pl/100)%10
    pl = max - 5
    return pl
}


for x in 0..<300 {
    for y in 0..<300 {
        var sum = 0
        let maxSize = min(300-x,300-y)
        for size in 1...maxSize {
            for i in 0..<size {
                sum += field[y+i][x+size-1]
            }
            for j in 0..<size-1 {
                sum += field[y+size-1][x+j]
            }
            if sum > max {
                max = sum;
                maxX = x
                maxY = y
                maxS = size
            }
        }
    }
}

print("Day_11_2: (\(maxX+1),\(maxY+1),\(maxS))")
