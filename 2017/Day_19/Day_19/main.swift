//
//  main.swift
//  Day_19
//
//  Created by Pavlo Liashenko on 18.09.2022.
//

import Foundation

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL)
let input = inputFileData.trimmingCharacters(in: .newlines)
var count = 300
var matrix : [[Character]] = Array(repeating: Array(repeating: Character(" "), count: count+2), count: count+2)

var row = 0
var col = 0
for char in input {
    if char != "\n" {
        matrix[row][col+1] = char
        col += 1
    } else {
        row += 1
        col = 0
    }
}

var x = 0
var y = 0
var dy = 1
var dx = 0
while matrix[0][x] == " " {
    x += 1
}
var end = false
var res = ""
var steps = 0
while !end {
    if matrix[y][x] == "+" {
        if (dx != 0) {
            if matrix[y+1][x] != " " {
                dy = 1
                dx = 0
            } else if matrix[y-1][x] != " " {
                dy = -1
                dx = 0
            }
        } else if (dy != 0) {
            if matrix[y][x+1] != " " {
                dx = 1
                dy = 0
            } else if matrix[y][x-1] != " " {
                dx = -1
                dy = 0
            }
        }
    }
    
    if (matrix[y][x] == " ") {
        break;
    } else {
        steps += 1
    }
    
    if matrix[y][x] != "+" && matrix[y][x] != "|" && matrix[y][x] != "-" {
        res += String(matrix[y][x])
    }
    
    x += dx
    y += dy
}

print("Day_19_1: \(res)")
print("Day_19_2: \(steps)")
