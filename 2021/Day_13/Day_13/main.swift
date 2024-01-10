//
//  main.swift
//  Day13
//
//  Created by Pavlo Liashenko on 13.12.2021.
//

import Foundation
import AdventOfCodeStarterPack

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL).trimmingCharacters(in: .whitespacesAndNewlines)
var parts = inputFileData.components(separatedBy:"\n\n")
var points = parts[0].components(separatedBy: .newlines).map{Position($0)!}
var folds = parts[1].components(separatedBy: .newlines).map{$0.components(separatedBy:.whitespaces).last!.components(separatedBy:"=")}.reduce(into: [Position]()) {
    var point : Position!
    let value = Int($1[1])!
    if $1[0] == "x" {
        point = Position(x: value)
    } else {
        point = Position(y: value)
    }
    $0.append(point)
}

for (step, fold) in folds.enumerated() {
    points = points.map {
        if fold.y == 0 {
            if $0.x > fold.x {
                return Position(fold.x - abs($0.x-fold.x), $0.y)
            }
        } else {
            if $0.y > fold.y {
                return Position($0.x, fold.y - abs($0.y-fold.y))
            }
        }
        return $0
    }
    if step == 0 {
        let set = Set<Position>(points)
        print("Day13_1: \(set.count)")//607
    }
}

print("Day13_2: ")//CPZLPFZL
pr(field(by: points))

func field(by points: [Position]) -> [[Bool]] {
    let maxX = points.max{$0.x < $1.x}!.x
    let maxY = points.max{$0.y < $1.y}!.y
    var field : [[Bool]] = Array(repeating: Array(repeating: false, count: maxX + 1), count: maxY + 1)
    for point in points {
        field[point.y][point.x] = true
    }
    return field
}

func pr(_ field : [[Bool]]) {
    var str = ""
    for line in field {
        for item in line {
            str += item ? "#" : " "
        }
        str += "\n"
    }
    print(str)
}
