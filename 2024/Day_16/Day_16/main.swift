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
var min = Int.max
let height = field.count
let width = field[0].count
var blanc = Array(repeating: Array(repeating: Int.max, count: width), count: height)
var map: [Direction:[[Int]]] = [.up : blanc, .right : blanc, .down : blanc, .left: blanc]
var tiles: [Position] = []
func findPath(_ pos: Position, _ dir: Direction, _ cost: Int, _ path: [Position] = []) {
    if cost > min { return }
    if map[dir]![pos] < cost {return}
    map[dir]![pos] = cost
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
    var path = path
    path.append(pos)
    if field[pos + dir] != "#" {
        findPath(pos + dir, dir, cost + 1, path)
    }
    if field[pos + dir.rotatedLeft()] != "#" {
        findPath(pos + dir.rotatedLeft(), dir.rotatedLeft(), cost + 1001, path)
    }
    if field[pos + dir.rotatedRight()] != "#" {
        findPath(pos + dir.rotatedRight(), dir.rotatedRight(), cost + 1001, path)
    }
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
