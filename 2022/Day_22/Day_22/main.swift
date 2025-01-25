//
//  main.swift
//  Day_22
//
//  Created by Pavlo Liashenko on 25.12.2022.
//

import Foundation

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL).trimmingCharacters(in: .newlines)
var parts = inputFileData.components(separatedBy:"\n\n")
var map = parts[0].components(separatedBy:.newlines).map{$0.map{$0}}
var width = map.map{$0.count}.max()!
var height = map.count
map = map.map{$0 + Array(repeating:" ", count: width - $0.count)}

var rotate : [Int] = [0]
var steps  : [Int] = []

var number = 0
for char in parts[1] {
    if let dight = char.wholeNumberValue {
        number *= 10
        number += dight
    } else {
        steps.append(number)
        number = 0
        if  char == "R" {
            rotate.append(1)
        } else {
            rotate.append(-1)
        }
    }
}
steps.append(number)

        //r d l u
let oX = [1,0,-1,0]
let oY = [0,1,0,-1]

infix operator %%

extension Int {
    static  func %% (_ left: Int, _ right: Int) -> Int { //mod
       let mod = left % right
       return mod >= 0 ? mod : mod + right
    }
}
func next1(_ x: Int, _ y: Int, _ i: Int) -> (x: Int, y: Int, i: Int) {
    var nx = x
    var ny = y
    let oI = i
    repeat {
        ny = (ny + oY[oI]) %% height
        nx = (nx + oX[oI]) %% map[ny].count
    } while map[ny][nx] == " "
    return (nx, ny, oI)
}

func next2(_ x: Int, _ y: Int, _ i: Int) -> (x: Int, y: Int, i: Int) {
    var nx = x
    var ny = y
    var ni = i
    ny = ny + oY[i]
    nx = nx + oX[i]
    switch (nx, ny, i) {//3
    case (50..<100, -1, 3)://+
        ny = nx + 100
        nx = 0
        ni  = 0 // right
        break
    case (-1, 150..<200, 2)://+
        nx = ny - 100
        ny = 0
        ni = 1 // down
        break
    case (100..<150, -1, 3)://+
        nx = nx - 100
        ny = 199
        ni = 3 //up
        break
    case (0..<50, 200, 1)://+
        nx = nx + 100
        ny = 0
        ni = 1 //down
        break
    case (49, 0..<50, 2)://+
        ny = 149 - ny
        nx = 0
        ni = 0//right
        break
    case (-1, 100..<150, 2)://+
        ny = 149 - ny
        nx = 50
        ni = 0//right
        break
    case (49, 50..<100, 2)://+
        nx = ny - 50
        ny = 100
        ni = 1 //down
        break
    case (0..<50, 99, 3)://+
        ny = nx + 50
        nx = 50
        ni = 0//right
        break
    case (150, 0..<50, 0)://+
        ny = 149 - ny//149
        nx = 99
        ni = 2 // left
        break
    case (100, 100..<150, 0)://+
        ny = 149 - ny//149
        nx = 149
        ni = 2 // left
        break
    case (100..<150, 50, 1)://+
        ny = nx - 50
        nx = 99
        ni = 2 // left
        break
    case (100, 50..<100, 0)://+
        nx = 50 + ny
        ny = 49
        ni = 3 //up
        break
    case (50..<100, 150, 1)://+
        ny = 100 + nx
        nx = 49
        ni = 2 // left
        break
    case (50, 150..<200, 0)://+
        nx = ny - 100
        ny = 149
        ni = 3 //up
        break
    default:
        break
    }

    return (nx, ny, ni)
}

func process(_ fx : (_ x: Int, _ y: Int, _ i: Int) -> (x: Int, y: Int, i: Int)) -> (x: Int, y: Int, i: Int) {
    var oI = 0
    var x = map[0].firstIndex(of:".")!
    var y = 0
    for i in 0..<steps.count {
        oI = (oI + rotate[i]) %% 4
        for _ in 0..<steps[i] {
            let n = fx(x, y, oI)
            if map[n.y][n.x] == "#" {break}
            x  = n.x
            y  = n.y
            oI = n.i
        }
    }
    return (x, y, oI)
}

let res1 = process(next1)
print("Day_22_1: \((res1.y+1)*1000 + 4*(res1.x+1) + res1.i)")//89224//95358

let res2 = process(next2)
print("Day_22_2: \((res2.y+1)*1000 + 4*(res2.x+1) + res2.i)")//136182//144361
