//
//  main.swift
//  Day_6
//
//  Created by Pavlo Liashenko on 06.12.2024.
//

import Foundation
import AdventOfCodeStarterPack

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL, encoding: .utf8).trimmingCharacters(in: .whitespacesAndNewlines)
var field = inputFileData.components(separatedBy:.newlines).map{$0.map{$0}}

var startPos: Position = .zero
var startDir: Direction = .up

exit: for y in 0 ..< field.count {
    let row = field[y]
    for x in 0 ..< row.count {
        startPos = Position(x, y)
        if let direction = Direction(field[startPos]) {
            startDir = direction
            break exit
        }
    }
}
var dir = startDir
var pos = startPos
var result1 = 0
while field.valid(position: pos) {
    if field[pos] != "X" {
        field[pos] = "X"
        result1 += 1
    }
    if !field.valid(position:pos + dir) {
        break;
    }
    while field[safe: pos + dir] == "#" {
        dir.rotateRight()
    }
    pos += dir
}
print("Day_6_1:", result1)


var result2 = 0
dir = startDir
pos = startPos
field[pos] = "."
var sets : [Position: Set<Direction>] = [:]
var reSpots = Set<Position>()
while field.valid(position: pos) {
    sets[pos, default: []].insert(dir)
    if !field.valid(position:pos + dir) {
        break;
    }

    while field[pos + dir] == "#" {
        dir.rotateRight()
    }
    
    if field[pos + dir] == "X" {
        field[pos + dir] = "#"
        var dir2 = dir
        dir2.rotateRight()
        var pos2 = pos
        var sets2 = sets
        while field.valid(position: pos2) {
            if let set = sets2[pos2],
               set.contains(dir2) {
                reSpots.insert(pos + dir)
                //field[pos + dir] = "*"
                //print(pos + dir)
                result2 += 1
                break;
            }
            sets2[pos2, default: []].insert(dir2)

            if !field.valid(position:pos2 + dir2) {
                break;
            }
            
            while field[safe: pos2 + dir2] == "#" {
                dir2.rotateRight()
            }

            pos2 += dir2

        }
        field[pos + dir] = "."
    }

    pos += dir
}

print("Day_6_2:", reSpots.count, result2)

//var test = field.reduce(into:"") {$0 += String($1)+"\n"}
//print(test)

//<2300
//>1983

//>1648
//>1638
//>1599
