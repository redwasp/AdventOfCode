//
//  main.swift
//  Day_1
//
//  Created by Pavlo Liashenko on 16.05.2022.
//

import Foundation

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL)
var basementIndex = 0
var index = 0
let result = inputFileData.reduce(into: 0) { sum, char in
    switch char {
    case ")":
        sum -= 1
    case "(":
        sum += 1
    default:
        break
    }
    
    //part 2
    index += 1
    if sum == -1 && basementIndex == 0 {
        basementIndex = index
    }
}
print("Day 1_1: \(result)")
print("Day 1_2: \(basementIndex)")
