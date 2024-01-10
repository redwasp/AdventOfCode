//
//  main.swift
//  Day_25
//
//  Created by Pavlo Liashenko on 25.12.2021.
//

import Foundation

enum FieldKind {
    case empty
    case east
    case south
}

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL).trimmingCharacters(in: .whitespacesAndNewlines)
var fields : [[FieldKind]] = inputFileData.components(separatedBy: .newlines).map{$0.map{
    switch $0 {
    case ".":
        return FieldKind.empty
    case ">":
        return FieldKind.east
    case "v":
        return FieldKind.south
    default:
        print("!!!Error")
        return FieldKind.empty
    }
}}
let height = fields.count
let width  = fields[0].count
var stop = false
var step = 0
while !stop {
    step += 1
    stop = true
    var toMove : [(x: Int, y: Int)] = []
    for y in 0..<height {
        for x in 0..<width {
            if fields[y][x] == .east,
               fields[y][(x+1)%width] == .empty {
                toMove.append((x, y))
            }
        }
    }
    if toMove.count > 0 {
        stop = false
        for (x, y) in toMove {
            fields[y][x] = .empty
            fields[y][(x+1)%width] = .east
        }
    }
    toMove = []
    for y in 0..<height {
        for x in 0..<width {
            if fields[y][x] == .south,
               fields[(y+1)%height][x] == .empty {
                toMove.append((x, y))
            }
        }
    }
    if toMove.count > 0 {
        stop = false
        for (x, y) in toMove {
            fields[y][x] = .empty
            fields[(y+1)%height][x] = .south
        }
    }
}

print("Day_25_1: \(step)")
