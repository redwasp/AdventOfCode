//
//  main.swift
//  Day_17
//
//  Created by Pavlo Liashenko on 25.12.2022.
//

import Foundation

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL).trimmingCharacters(in: .whitespacesAndNewlines)
var pattern = inputFileData.map{$0 == ">"}
var line : [Bool]   = Array(repeating: false, count: 7)
var cave : [[Bool]] = Array(repeating: line, count: 6)

var rocks : [[[Bool]]] = [
    [[true, true, true, true]],
    
    [[false, true, false],
    [true, true, true],
    [false, true, false]],
    
    [[true, true, true],
    [false, false, true],
    [false, false, true]],
    
    [[true],
    [true],
    [true],
    [true]],
    
    [[true, true],
     [true, true]]
]

var caveHeight = 0
var pos = 0
var array : [Int] = []
for step in 0..<200000 {
    let rock = rocks[step % 5]
    let additive = (caveHeight + rock.count + 3) - cave.count
    if additive > 0 {
        cave.append(contentsOf: Array(repeating: line, count: additive))
    }
    var x = 2
    var y = caveHeight + 3
    var stop = false
    while !stop {
        let right = pattern[pos]
        pos += 1
        pos %= pattern.count
        let newX = x + (right ? 1 : -1)
        if isValid(rock, cave, newX, y) {
            x = newX
        }
        
        if isValid(rock, cave, x, y-1) {
            y -= 1
        } else {
            stop = true
        }
    }
    
    //paste
    for i in 0..<rock.count {
        for j in 0..<rock[0].count {
            if rock[i][j] {
                if cave[y+i][x+j] {
                    print("Error!!!")
                }
                cave[y+i][x+j] = true
            }
        }
    }
    let oldCaveHeight = caveHeight
    caveHeight = max(caveHeight, y + rock.count)
    array.append(caveHeight - oldCaveHeight)
    if step == 2021 {
        print("Day_17_1: \(caveHeight)")
    }
}

var pat = 1700

var offset = 1000

for c in 100..<100000 {
    if array[offset..<offset+c] == array[offset+c..<offset+2*c] {
        pat = c
        break
    }
}

var tail = (1000000000000-offset) % pat
var rep  = (1000000000000-offset) / pat

let sum = array[0..<offset].reduce(0, +) +  rep * array[offset..<offset+pat].reduce(0, +) + array[offset..<offset+tail].reduce(0, +)
print("Day_17_2: \(sum)")

func pq() {
    let grid = cave.reversed().reduce(into: "") { $0 += $1.reduce(into: "") { $0 += $1 ? "#":"."} + "\r"}
    print("\(grid)")
}

func isValid(_ rock: [[Bool]], _ cave: [[Bool]], _ x: Int, _ y: Int) -> Bool {
    guard y >= 0 else {return false}
    guard x >= 0 else {return false}
    guard x + rock[0].count <= 7 else {return false}
    for i in 0..<rock.count {
        for j in 0..<rock[0].count {
            if rock[i][j] && cave[y+i][x+j] {
                return false
            }
        }
    }
    return true
}
