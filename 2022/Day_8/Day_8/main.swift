//
//  main.swift
//  Day_8
//
//  Created by Pavlo Liashenko on 10.12.2022.
//

import Foundation

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let string = try! String(contentsOf: inputFileURL).trimmingCharacters(in: .newlines)
let grid = string.split(separator:"\n").map{$0.map{$0.wholeNumberValue!}}

let height = grid.count
let width  = grid[0].count

func isVisible(_ x: Int,_ y: Int) -> Bool {
    guard x != 0 && x != width-1 else {return true}
    guard y != 0 && y != height-1 else {return true}
    let value = grid[y][x]
    var isVisible = true
    for xi in x+1..<width {
        if grid[y][xi] >=  value {
            isVisible = false
        }
    }
    if isVisible {return true}
    isVisible = true
    for xi in 0..<x {
        if grid[y][xi] >= value {
            isVisible = false
        }
    }
    if isVisible {return true}
    isVisible = true
    for yi in y+1..<height {
        if grid[yi][x] >= value {
            isVisible = false
        }
    }
    if isVisible {return true}
    isVisible = true
    for yi in 0..<y {
        if grid[yi][x] >= value {
            isVisible = false
        }
    }
    if isVisible {return true}
    return false
}

func score(_ x: Int,_ y: Int) -> Int {
    guard x != 0 && x != width-1 else {return 0}
    guard y != 0 && y != height-1 else {return 0}
    let value = grid[y][x]
    var scores : [Int] = [0,0,0,0]
    for xi in x+1..<width {
        scores[0] += 1
        if grid[y][xi] >= value {
            break
        }
    }
    for xi in (0..<x).reversed() {
        scores[1] += 1
        if grid[y][xi] >= value {
            break
        }
    }
    for yi in y+1..<height {
        scores[2] += 1
        if grid[yi][x] >= value {
            break
        }
    }
    for yi in (0..<y).reversed() {
        scores[3] += 1
        if grid[yi][x] >= value {
            break
        }
    }

    let score = scores.reduce(1, *)
    return score
}

var count = 0
for y in 0..<grid.count {
    for x in 0..<grid[y].count {
        if isVisible(x,y) {
            count += 1
        }
    }
}
print("Day_8_1: \(count)")

var max = 0
for y in 0..<grid.count {
    for x in 0..<grid[y].count {
        let score = score(x,y)
        if max < score {
            max = score
        }
    }
}
print("Day_8_2: \(max)")
