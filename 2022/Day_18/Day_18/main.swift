//
//  main.swift
//  Day_18
//
//  Created by Pavlo Liashenko on 20.12.2022.
//

import Foundation

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL).trimmingCharacters(in: .whitespacesAndNewlines)
var points = inputFileData.components(separatedBy:.newlines).map{$0.components(separatedBy: ",").map{Int($0)!}}
var maxX = points.map{$0[0]}.max()!
var maxY = points.map{$0[1]}.max()!
var maxZ = points.map{$0[2]}.max()!
var grid : [[[Bool]]] = Array(repeating: Array(repeating: Array(repeating: false, count: maxX+3), count: maxY+3), count: maxZ+3)
for point in points {
    grid[point[2]+1][point[1]+1][point[0]+1] = true
}
var area = 0
for point in points {
    if !grid[point[2]+1][point[1]+1][point[0]+2] {area += 1}
    if !grid[point[2]+1][point[1]+2][point[0]+1] {area += 1}
    if !grid[point[2]+2][point[1]+1][point[0]+1] {area += 1}
    if !grid[point[2]+1][point[1]+1][point[0]] {area += 1}
    if !grid[point[2]+1][point[1]][point[0]+1] {area += 1}
    if !grid[point[2]][point[1]+1][point[0]+1] {area += 1}
}
print("Day_18_1: \(area)")


var grid2 : [[[Bool]]] = Array(repeating: Array(repeating: Array(repeating: false, count: maxX+3), count: maxY+3), count: maxZ+3)
var pp = [[0,0,0]]
while pp.count != 0 {
    var newPoints: [[Int]] = []
    for point in pp {
        guard !grid2[point[2]][point[1]][point[0]] else {continue}
        grid2[point[2]][point[1]][point[0]] = true
        if point[0] < maxX+2 && !grid[point[2]][point[1]][point[0]+1] {newPoints.append([point[0]+1,point[1],point[2]])}
        if point[1] < maxY+2 && !grid[point[2]][point[1]+1][point[0]] {newPoints.append([point[0],point[1]+1,point[2]])}
        if point[2] < maxZ+2 && !grid[point[2]+1][point[1]][point[0]] {newPoints.append([point[0],point[1],point[2]+1])}
        if point[0] > 0 && !grid[point[2]][point[1]][point[0]-1] {newPoints.append([point[0]-1,point[1],point[2]])}
        if point[1] > 0 && !grid[point[2]][point[1]-1][point[0]] {newPoints.append([point[0],point[1]-1,point[2]])}
        if point[2] > 0 && !grid[point[2]-1][point[1]][point[0]] {newPoints.append([point[0],point[1],point[2]-1])}
    }
    pp = newPoints
}

area = 0
for point in points {
    if !grid[point[2]+1][point[1]+1][point[0]+2] && grid2[point[2]+1][point[1]+1][point[0]+2] {area += 1}
    if !grid[point[2]+1][point[1]+2][point[0]+1] && grid2[point[2]+1][point[1]+2][point[0]+1] {area += 1}
    if !grid[point[2]+2][point[1]+1][point[0]+1] && grid2[point[2]+2][point[1]+1][point[0]+1] {area += 1}
    if !grid[point[2]+1][point[1]+1][point[0]] && grid2[point[2]+1][point[1]+1][point[0]] {area += 1}
    if !grid[point[2]+1][point[1]][point[0]+1] && grid2[point[2]+1][point[1]][point[0]+1]  {area += 1}
    if !grid[point[2]][point[1]+1][point[0]+1] && grid2[point[2]][point[1]+1][point[0]+1] {area += 1}
}
print("Day_18_2: \(area)")
