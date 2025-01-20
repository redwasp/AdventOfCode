//
//  main.swift
//  Day_3
//
//  Created by Pavlo Liashenko on 17.01.2025.
//

import Foundation

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL, encoding: .utf8).trimmingCharacters(in: .whitespacesAndNewlines)
struct Claim {
    let id: Int
    let x1: Int
    let y1: Int
    let x2: Int
    let y2: Int
    init(_ id: Int, _ x: Int,_ y: Int,_ width: Int,_ height: Int) {
        self.id = id
        self.x1 = x
        self.y1 = y
        self.x2 = x + width
        self.y2 = y + height
    }
    init(_ d: [Int]) {
        self.init(d[0], d[1], d[2], d[3], d[4])
    }
}
let nonNumericCharacters = CharacterSet(charactersIn: "0123456789").inverted
let claims = inputFileData
    .components(separatedBy: .newlines)
    .map {
        Claim($0.components(separatedBy:nonNumericCharacters)
            .filter{!$0.isEmpty}
            .compactMap {
                Int($0)
            })
        }
let width = claims.max{$0.x2 < $1.x2}!.x2
let height = claims.max{$0.y2 < $1.y2}!.y2
var field = Array(repeating: Array(repeating: 0, count: width), count: height)
var set: Set<Int> = []
for claim in claims {
    set.insert(claim.id)
    for x in claim.x1..<claim.x2 {
        for y in claim.y1..<claim.y2 {
            switch field[y][x] {
            case 0:
                field[y][x] = claim.id
            case -1:
                set.remove(claim.id)
            case let value:
                set.remove(value)
                set.remove(claim.id)
                field[y][x] = -1
            }
        }
    }
}
let overlaps = field.reduce(0){$0 + $1.reduce(0){$0 + ($1 == -1 ? 1 : 0)}}

print("Day_3_1:", overlaps)
print("Day_3_2:", set.first!)
