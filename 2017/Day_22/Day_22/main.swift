//
//  main.swift
//  Day_22
//
//  Created by Pavlo Liashenko on 04.10.2022.
//

import Foundation

let inputData = try! Data(contentsOf: URL(fileURLWithPath:"input.txt"))
let inputString = String(data:inputData , encoding: .utf8)!
var matrixInput = inputString.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines).map{ return String($0).map{ return $0 == "#"}}
let n = 151
var matrix = Array(repeating:Array(repeating:false, count:matrixInput.count*n) , count:matrixInput.count*n)
let di = (n/2)*matrixInput.count
let dj = (n/2)*matrixInput[0].count

for i in 0..<matrixInput.count {
    for j in 0..<matrixInput[i].count {
        matrix[di+i][dj+j] = matrixInput[i][j]
    }
}

var field = matrix.map{$0.map{$0 ? 2 : 0}}

var y = matrix.count/2
var x = matrix[0].count/2
var dx = [0,1,0,-1]
var dy = [1,0,-1,0]

var facing = 2
var steps = 10000
var count = 0
for _ in 0..<steps {
    count += matrix[y][x] ? 0 : 1
    facing = (4 + facing + (matrix[y][x] ? -1 : 1))%4
    matrix[y][x] = !matrix[y][x]
    x += dx[facing]
    y += dy[facing]
}
print("Day_22_1: \(count)")//5339

facing = 2
steps = 10000000
count = 0
y = field.count/2
x = field[0].count/2

for _ in 0..<steps {
    switch field[y][x] {
    case 0:
        facing = (4+facing+1)%4
    case 1:
        count += 1
    case 2:
        facing = (4+facing-1)%4
    case 3:
        facing = (facing+2)%4
    default:
        break
    }
    field[y][x] = (field[y][x]+1)%4
    x += dx[facing]
    y += dy[facing]
}

print("Day_22_2: \(count)")//2512380


