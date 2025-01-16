//
//  main.swift
//  Day_16
//
//  Created by Pavlo Liashenko on 17.12.2024.
//

import Foundation
import AdventOfCodeStarterPack

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL, encoding: .utf8).trimmingCharacters(in: .whitespacesAndNewlines)
let field = inputFileData.components(separatedBy: .newlines).map{$0.map{$0}}
let height = field.count
let width = field[0].count
var min = height * 1000//Int.max
var blanc = Array(repeating: Array(repeating: Int.max, count: width), count: height)
var map: [[[Int]]] = Array(repeating: blanc, count: 4)
var tiles: [Position] = []
var path: [Position] = []
//TODO: Replace recursion with a loop
func findPath(_ pos: Position, _ dir: Direction, _ cost: Int) {
    if cost > min { return }
    if map[dir.index][pos] < cost {return}
    map[dir.index][pos] = cost
    if field[pos] == "E" {
        if cost == min {
            tiles.append(contentsOf: path)
        } else
        if cost < min {
            min = cost
            tiles = Array(path)
        }
        return
    }
    path.append(pos)
    if field[pos + dir] != "#" {
        findPath(pos + dir, dir, cost + 1)
    }
    if field[pos + dir.rotatedLeft()] != "#" {
        findPath(pos + dir.rotatedLeft(), dir.rotatedLeft(), cost + 1001)
    }
    if field[pos + dir.rotatedRight()] != "#" {
        findPath(pos + dir.rotatedRight(), dir.rotatedRight(), cost + 1001)
    }
    path.removeLast()
}

exit: for (y,row) in field.enumerated() {
    for (x, char) in row.enumerated() {
        if char == "S" {
            findPath(Position(x, y), .east, 0)
            break exit
        }
    }
}
print("Day_16_1:\(min)")//85432
print("Day_16_1:\(Set(tiles).count + 1)")//465
