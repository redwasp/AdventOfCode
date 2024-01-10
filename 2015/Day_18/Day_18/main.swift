//
//  main.swift
//  Day_18
//
//  Created by Pavlo Liashenko on 21.06.2022.
//

import Foundation

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL)
let lines = inputFileData.split(separator: "\n", omittingEmptySubsequences: true)
let field : [[Bool]] = lines.map{$0.map{$0 == "#"}}
let dx = [1, 1,  1, 0,  0, -1, -1, -1]
let dy = [1, 0, -1, 1, -1,  1,  0, -1]

func countOnLights(_ x: Int, _ y: Int, in field: [[Bool]]) -> Int {
    var count = 0
    for i in 0..<8 {
        let x = x + dx[i]
        let y = y + dy[i]
        guard field.indices.contains(y),
              field[0].indices.contains(x) else {continue}
        if field[y][x] {count += 1}
    }
    return count;
}

func switchLights(_ field: [[Bool]]) -> [[Bool]] {
    var newField = field
    for y in 0..<field.count {
        for x in 0..<field[0].count {
            let count = countOnLights(x, y, in: field)
            if field[y][x] {
                newField[y][x] = count == 2 || count == 3
            } else {
                newField[y][x] = count == 3
            }
        }
    }
    return newField
}

func pr(_ field: [[Bool]]) {
    var str = ""
    for y in 0..<field.count {
        str += "\r"
        for x in 0..<field[0].count {
            str += field[y][x] ? "#" : "."
        }
    }
    print(str)
}

var newField = field

for _ in 1...100 {
    newField = switchLights(newField)
}

var res = newField.reduce(into: 0){$0 += $1.reduce(into: 0) {$0 += $1 ? 1 : 0}}
    
print("Day_18_1: \(res)")


newField = field
for _ in 1...100 {
    newField[0][0] = true
    newField[newField.count-1][0] = true
    newField[0][newField[0].count-1] = true
    newField[newField.count-1][newField[0].count-1] = true
    newField = switchLights(newField)
}
newField[0][0] = true
newField[newField.count-1][0] = true
newField[0][newField[0].count-1] = true
newField[newField.count-1][newField[0].count-1] = true

res = newField.reduce(into: 0){$0 += $1.reduce(into: 0) {$0 += $1 ? 1 : 0}}
print("Day_18_2: \(res)")
