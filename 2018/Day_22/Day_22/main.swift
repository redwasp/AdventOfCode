//
//  main.swift
//  Day_22
//
//  Created by Pavlo Liashenko on 26.01.2023.
//

import Foundation

//depth: 4080
//target: 14,785

var depth = 4080//11991
var tX = 14//6
var tY = 785//797
//depth = 510
//tX = 10
//tY = 10

var sizeX = tX+1100
var sizeY = tY+1100


let m  = 20183
var gi : [[Int]] = Array.init(repeating: Array.init(repeating: 0, count: sizeX), count: sizeY)
var el : [[Int]] = Array.init(repeating: Array.init(repeating: 0, count: sizeX), count: sizeY)
var f : [[Int]] = Array.init(repeating: Array.init(repeating: 0, count: sizeX), count: sizeY)
var ff : [[Int]] = Array.init(repeating: Array.init(repeating: 0, count: sizeX), count: sizeY)
var fff : [[[Int]]] = Array.init(repeating:Array.init(repeating: Array.init(repeating: Int.max, count: sizeX), count: sizeY), count: 3)
fff[1][0][0] = 0

var sum  = 0
var xxx = ((16807*48271)+depth)%m

for y in 0..<sizeY {
    for x in 0..<sizeX {
        if y == tY && x == tX {
            gi[y][x] = 0
        } else if y == 0 {
            gi[y][x] = (x * 16807)%m
        } else if x == 0 {
            gi[y][x] = (y * 48271)%m
        } else {
            gi[y][x] = (el[y][x-1] * el[y-1][x])%m
        }
        el[y][x] = (gi[y][x]+depth)%m
        if y <= tY && x <= tX {
            sum += el[y][x]%3
        }
        f[y][x] = el[y][x]%3
    }
}
print("Result 1 : ", sum)

let nx = [0,1,-1,0]
let ny = [1,0,0,-1]

var points : [(x:Int, y:Int, tool:Int, m:Int)] = [(x:0,y:0,tool:1,m:0)];

while points.count != 0 {
    
    var newPoints : [(x:Int, y:Int, tool:Int, m:Int)] = []
    for point in points {
        let x = point.x
        let y = point.y
        let tool = point.tool
        let min = point.m;
        if (x == tX && y == tY) {
            print(x,y,min,tool);
        }
    
        for i in 0...3 {
            let xN = x+nx[i]
            let yN = y+ny[i]
            if xN >= 0 && yN >= 0 && xN < sizeX && yN < sizeY {
                var s = min+1
                var nT = tool
                if f[yN][xN] == tool {
                    if f[y][x] != (tool+1)%3 {
                        nT = (tool+1)%3
                    } else {
                        nT = (tool+2)%3
                    }
                    s += 7;
                }
                if fff[nT][yN][xN] > s && fff[nT][tY][tX] > s {
                   fff[nT][yN][xN] = s
                    newPoints.append((x: xN, y: yN, tool: nT, m: s))
                }
            }
        }
    }
    points = newPoints
}

print("Result 2 :",min(fff[1][tY][tX],fff[2][tY][tX]+7))
//for row in f {
//    print(row)
//}
//for i in 0..<ff.count {
//    for j in 0..<ff[i].count {
//        ff[i][j] = min(min(fff[0][i][j],fff[1][i][j]),fff[2][i][j])
//        if ff[i][j] == Int.max {
//            ff[i][j] = 0
//        }
//    }
//}
//
//for row in ff {
//    print(row)
//}


