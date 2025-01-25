//
//  main.swift
//  Day_2
//
//  Created by Pavlo Liashenko on 02.12.2022.
//

import Foundation

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL).trimmingCharacters(in: .whitespacesAndNewlines)
var rounds = inputFileData.components(separatedBy:"\n").map{$0.components(separatedBy: .whitespaces)}

var score = 0
for round in rounds {
    
    switch round[1] {
    case "X":
        score += 1
    case "Y":
        score += 2
    case "Z":
        score += 3
    default:
        break
    }
    
    switch (round[0], round[1]) {
    case ("A", "X"), ("B", "Y"), ("C", "Z"):
        score += 3
    case ("C", "X"), ("A", "Y"), ("B", "Z"):
        score += 6
    default:
        break
    }
}

print("Day_2_1: \(score)")


score = 0
for round in rounds {
    
    switch round[1] {
    case "Y":
        score += 3
    case "Z":
        score += 6
    default:
        break
    }
    
    switch (round[0], round[1]) {
    case ("B", "X"), ("A", "Y"), ("C", "Z"):
        score += 1
    case ("C", "X"), ("B", "Y"), ("A", "Z"):
        score += 2
    case ("A", "X"), ("C", "Y"), ("B", "Z"):
        score += 3
    default:
        break
    }
}

print("Day_2_2: \(score)")


