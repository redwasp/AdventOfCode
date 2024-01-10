//
//  main.swift
//  Day_6
//
//  Created by Pavlo Liashenko on 06.12.2023.
//

import Foundation

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL)
                        .trimmingCharacters(in: .whitespacesAndNewlines)
let lines = inputFileData
            .components(separatedBy: .newlines)
            .map {
    $0.components(separatedBy: ":")[1]
      .components(separatedBy: .whitespaces)
}

let races = lines.map {
    $0.compactMap{
        Int($0)
    }
}

let times = races[0]
let distances = races[1]
var result1 = 1
for i in 0..<times.count {
    let time = times[i]
    let distance = distances[i]
    result1 *= waysCount(time, distance)
}
print("Day_6_1: \(result1)")//1084752
//168912 - height

let race = lines.map {
    $0.joined()
}.map {
    Int($0)!
}

let time = race[0]
let distance = race[1]
let result2 = waysCount(time, distance)

print("Day_6_2: \(result2)")//28228952

func waysCount(_ time: Int, _ distance: Int) -> Int {
    let sD = sqrt(Double(time*time - 4*distance))
    let x1 = Int(floor((Double(time) - sD)/2))
    let x2 = Int(ceil((Double(time) + sD)/2))
    let count = x2 - x1 - 1
    return count
}
