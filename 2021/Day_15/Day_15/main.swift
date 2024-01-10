//
//  main.swift
//  Day_15
//
//  Created by Pavlo Liashenko on 15.12.2021.
//

import Foundation

struct Point : Hashable {
    let x: Int
    let y: Int
    
    init(_ x: Int, _ y: Int) {
        self.x = x
        self.y = y
    }
}

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL).trimmingCharacters(in: .whitespacesAndNewlines)
let field = inputFileData.components(separatedBy: .newlines).map{$0.map{Int(String($0))!}}
var width = field[0].count
var height = field.count
var endX = width - 1
var endY = height - 1
var minLast = Int.max
var minF : [[Int]] = Array(repeating: Array(repeating: minLast, count: width), count: height)
func findPath(_ x: Int, _ y: Int, _ sum: Int) {
    var sum = sum
    sum += field[y][x]
    if sum < minF[y][x] && sum < minLast {
        minF[y][x] = sum
        if y == endY && x == endX {
            minLast = sum
        } else {
            var next : [[Int]] = []
            if x < endX {
                next.append([x+1, y])
            }
            if y < endY {
                if x < endX && field[y][x+1] > field[y+1][x]  {
                    next.insert([x, y+1], at: 0)
                } else {
                    next.append([x, y+1])
                }
            }

            if x > 0 {
                next.append([x-1, y])
            }
            if y > 0 {
                if x > 0 && field[y][x-1] > field[y-1][x]  {
                    next.insert([x, y-1], at: next.count-1)
                } else {
                    next.append([x, y-1])
                }
            }
            for n in next {
                findPath(n[0], n[1], sum)
            }
        }
    }
}

findPath(0, 0, -field[0][0])
print("Day14_1: \(minF.last!.last!)")

minF = Array(repeating: Array(repeating: 0, count: width*5), count: height*5)
var fullField : [[Int]] = Array(repeating: Array(repeating: 0, count: width*5), count: height*5)
for x in 0..<5*width {
    for y in 0..<5*height {
        let dx = x % width
        let dy = y % height
        let offset = x/width + y/height
        var item = field[dy][dx] + offset
        if item > 9 {
            item -= 9
        }
        fullField[y][x] = item
    }
}
var s = 0
for x in 0..<5*width {
    for y in 0..<5*height {
        var value : Int!
        if x == 0 && y == 0 {
            value = -fullField[0][0]
        } else if x == 0 {
            value = minF[y-1][x]
        } else if y == 0 {
            value = minF[y][x-1]
        } else {
            value = min(minF[y-1][x], minF[y][x-1])
        }
        minF[y][x] = value + fullField[y][x]
    }
}

var complete = false
while !complete {
    complete = true
    for x in 0..<5*width {
        for y in 0..<5*height {
            if (y+1 < 5*height) && (minF[y][x] > minF[y+1][x] + fullField[y][x]) {
                minF[y][x] = minF[y+1][x] + fullField[y][x]
                complete = false
            }
            if (x+1 < 5*width) && (minF[y][x] > minF[y][x+1] + fullField[y][x]) {
                minF[y][x] = minF[y][x+1] + fullField[y][x]
                complete = false
            }
        }
    }
    for x in 1..<5*width {
        for y in 1..<5*height {
            let value = min(minF[y-1][x], minF[y][x-1])
            if minF[y][x]  > value + fullField[y][x] {
                minF[y][x] = value + fullField[y][x]
                complete = false
            }
        }
    }
}

print("Day14_2: \(minF.last!.last!)")
