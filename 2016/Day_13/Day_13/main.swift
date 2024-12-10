//
//  main.swift
//  Day_13
//
//  Created by Pavlo Liashenko on 12.08.2022.
//

import Foundation

let input = 1358

func isOpenSpace(_ x: Int, _ y: Int) -> Bool {
    var sum = x*x + 3*x + 2*x*y + y + y*y + input
    var count = 0
    while sum != 0 {
        count += sum%2
        sum >>= 1
    }
    return count % 2 == 0
}

let tX = 31
let tY = 39

let dX = [1, -1, 0,  0]
let dY = [0,  0, 1, -1]

var used  : Set<Int> = []
var points: [(x: Int, y: Int)]  = [(1, 1)]
var exit = false
var count = 0
while !exit {
    count += 1
    var nPoints: [(x: Int, y: Int)] = []
    for point in points {
        for i in 0..<4 {
            let nX = point.x + dX[i]
            let nY = point.y + dY[i]
            guard nX >= 0 else {continue}
            guard nY >= 0 else {continue}
            if nX == tX && nY == tY {
                exit = true
                break
            }
            guard isOpenSpace(nX, nY) else {continue}
            let key = nX*1000 + nY
            guard !used.contains(key) else {continue}
            nPoints.append((nX, nY))
            used.insert(key)
        }
        if exit {
            break
        }
        points = nPoints
    }
}
print("Day_13_1: \(count)")

used = []
points = [(1, 1)]

for _ in 1...50 {
    var nPoints: [(x: Int, y: Int)] = []
    for point in points {
        for i in 0..<4 {
            let nX = point.x + dX[i]
            let nY = point.y + dY[i]
            guard nX >= 0 else {continue}
            guard nY >= 0 else {continue}
            guard isOpenSpace(nX, nY) else {continue}
            let key = nX*1000 + nY
            guard !used.contains(key) else {continue}
            nPoints.append((nX, nY))
            used.insert(key)
        }
        points = nPoints
    }
}
print("Day_13_2: \(used.count)")
