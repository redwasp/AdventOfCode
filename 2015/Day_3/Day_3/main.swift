//
//  main.swift
//  Day_3
//
//  Created by Pavlo Liashenko on 16.05.2022.
//

import Foundation
import AdventOfCodeStarterPack

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL).trimmingCharacters(in: .whitespacesAndNewlines)
var point = Position.zero
let directions = inputFileData.map{Direction($0)!}
var santaPoint = Position.zero
var houses = directions.reduce(into:Set<Position>(), {
    santaPoint += $1
    $0.insert(santaPoint)
})

print("Day_3_1: \(houses.count)")

houses.removeAll()
santaPoint = .zero
var roboPoint = Position.zero
var step = 0
for (index, direction) in directions.enumerated() {
    if (index+1) % 2 == 0 {
        santaPoint += direction
        houses.insert(santaPoint)
    } else {
        roboPoint += direction
        houses.insert(roboPoint)
    }
}
print("Day_3_2: \(houses.count)")
