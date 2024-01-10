//
//  main.swift
//  Day_17
//
//  Created by Pavlo Liashenko on 17.12.2021.
//

import Foundation

//target area: x=88..125, y=-157..-103
let targetX = 88 ... 125
let targetY = -157 ... -103

//x=20..30, y=-10..-5
//let targetX = 20 ... 30
//let targetY = -10 ... -5
var maxs : [Int] = []
func test(_ vX:Int, _ vY:Int) -> Bool {
    var x = 0
    var y = 0
    var vX = vX
    var vY = vY
    var maxY = Int.min
    while y >= targetY.lowerBound {
        x += vX
        y += vY
        if y > maxY {
            maxY = y
        }
        if targetX.contains(x) && targetY.contains(y) {
            maxs.append(maxY)
            return true
        }
        if vX != 0 {
            vX -= vX > 0 ? 1 : -1
        }
        vY -= 1
    }
    return false
}
var count = 0
for vX in -200...200 {
    for vY in -200...200 {
        if test(vX,vY) {
            count += 1
        }
    }
}
print("Day17_1:\(maxs.max()!)");
print("Day17_2:\(count)");
