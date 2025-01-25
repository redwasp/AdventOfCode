//
//  main.swift
//  Day_3
//
//  Created by Pavlo Liashenko on 09.09.2022.
//

import Foundation

let input = 277678//312051
let circleNumber = Int(ceil((sqrt(Double(input)) - 1)/2))
let x = (circleNumber)*(circleNumber-1)/2
let ax = x*8 + 1
let xn = input - ax
let offset = xn - circleNumber
let dx = circleNumber*2
let yn = min(offset % dx, dx - offset % dx)
let res = circleNumber + yn

print("Day_3_1: \(res)")

var matrix:[[Int]] = [[Int]](repeating:[Int](repeating:0, count: 100), count:100)
var i = 50
var j = 50
var value = 1
matrix[i][j] = 1
j += 1
while value < input {
    value = 0
    for ii in -1...1 {
        for jj in -1...1 {
            value += matrix[i+ii][j+jj]
        }
    }
    matrix[i][j]=value
    if matrix[i][j-1] != 0 && matrix[i-1][j]==0 {
        i -= 1
    } else if matrix[i+1][j] != 0 && matrix[i][j-1]==0 {
        j -= 1
    } else if matrix[i][j+1] != 0 && matrix[i+1][j]==0 {
        i += 1
    } else if matrix[i-1][j] != 0 && matrix[i][j+1]==0 {
        j += 1
    }
}
print("Day_3_2: \(value)")
