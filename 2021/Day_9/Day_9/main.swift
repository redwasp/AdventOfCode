//
//  main.swift
//  Day_9
//
//  Created by Pavlo Liashenko on 10.12.2021.
//

import Foundation
import AdventOfCodeStarterPack

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL).trimmingCharacters(in: .whitespacesAndNewlines)
var field = inputFileData.components(separatedBy:.newlines).map{$0.map{Int(String($0))!}}

let width = field[0].count
let height = field.count
var basins : [Set<Position>] = []
var sum = 0
for x in 0..<width {
    for y in 0..<height {
        let position = Position(x, y)
        let value = field[position]
        if y == 0 || field[position.up] > value ,
           x == 0 || field[position.left] > value ,
           y == height-1 || field[position.down] > value ,
           x == width-1  || field[position.right] > value {
            sum += 1 + value
            var points : Set<Position> = []
            var parts  : [Position] = [position]
            while parts.count != 0 {
                let point = parts.removeFirst()
                guard !points.contains(point) else {continue}
                guard let value = field[safe: point], value != 9 else {continue}
                points.insert(point)
                parts.append(contentsOf: Directions.clockwise.map{point + $0})
            }
            basins.append(points)
        }
    }
}

print("Day_9_1: \(sum)")//577

basins.sort{$0.count > $1.count}
let sum2 = basins[0..<3].map{$0.count}.reduce(1,*)

print("Day_9_2: \(sum2)")//1069200
