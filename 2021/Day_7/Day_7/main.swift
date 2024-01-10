//
//  main.swift
//  Day_7
//
//  Created by Pavlo Liashenko on 07.12.2021.
//

import Foundation

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL).trimmingCharacters(in: .whitespacesAndNewlines)
var positions = inputFileData.components(separatedBy:",").compactMap{Int($0)}
positions.sort()
var med = positions[positions.count/2]
let target = med
let fuel = positions.reduce(0) { $0 + abs($1-target)}
print("Day_7_1: \(fuel)")

let max = positions.max()!
var fuel_min = Int.max
for i in 0..<max {
    let fuel = positions.reduce(0) {
        let n = abs($1-i)
        let x = (n*(n+1))/2
        return $0 + x
    }
    if fuel < fuel_min {
        fuel_min = fuel
    }
}
print("Day_7_2: \(fuel_min)")
