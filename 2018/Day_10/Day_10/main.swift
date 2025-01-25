//
//  main.swift
//  Day_10
//
//  Created by Pavlo Liashenko on 18.01.2023.
//

import Foundation

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL).trimmingCharacters(in: .whitespacesAndNewlines)
let points = inputFileData.components(separatedBy:.newlines).map{Point($0)}

struct Point : CustomStringConvertible {
    var position: Position
    var velocity: Position
    init(_ str: String) {
        let parts = str.components(separatedBy:"=<").dropFirst().map{$0.components(separatedBy:">")}.map{$0[0].components(separatedBy:",").map{$0.trimmingCharacters(in:.whitespaces)}.map{Int($0)!}}
        self.position = Position(parts[0][0], parts[0][1])
        self.velocity = Position(parts[1][0], parts[1][1])
    }
    var description: String {
        "X:\(position.x) Y:\(position.y) Vx:\(velocity.x) Vy:\(velocity.y)\r"
    }
}

struct Position: Hashable {
    let x, y : Int
    
    init(_ x: Int, _ y: Int) {
        self.x = x
        self.y = y
    }
    
    init(_ string: String) {
        let parts = string.components(separatedBy:", ").map{Int($0)!}
        self.x = parts[0]
        self.y = parts[1]
    }
    
    static func + (left: Position, right: Position) -> Position {
        return Position(left.x + right.x, left.y + right.y)
    }
    
    static func += (left: inout Position, right: Position) {
        left = left + right
    }
    
    static func - (left: Position, right: Position) -> Position {
        return Position(left.x - right.x, left.y - right.y)
    }
    
    static func -= (left: inout Position, right: Position) {
        left = left - right
    }
    
    static func * (position: Position, multiplier: Int) -> Position {
        return Position(position.x*multiplier, position.y*multiplier)
    }
}

func process(_ points : [Point], _ time: Int) -> [Point] {
    points.map {
        var pos = $0
        pos.position = pos.position + pos.velocity*time
        return pos
    }
}

func dist(_ points : [Point]) -> Int {
    var res = 0
    for i in 0..<points.count-1 {
        for j in (i+1)..<points.count {
            let p = points[i].position - points[j].position
            res += abs(p.x)
            res += abs(p.y)
        }
    }
    return res
}

var min = Int.max
var seconds = 0

for s in 10000..<11000 {//TODO: Golden Ratio Extremum Find
    let p = process(points, s)
    let dist = dist(p)
    if min > dist {
        min = dist
        seconds = s
    }
}
var p = process(points, seconds)
var offset = Position(p.map{$0.position.x}.min()!,p.map{$0.position.y}.min()!)
p = p.map{
    var pos = $0
    pos.position = pos.position - offset
    return pos
}
var max = Position(p.map{$0.position.x}.max()!, p.map{$0.position.y}.max()!)
var field : [[Bool]] = Array(repeating: Array(repeating: false, count: max.x+1), count: max.y+1)
for point in p {
    field[point.position.y][point.position.x] = true
}
var str = ""
for line in field {
    for item in line {
        str += item ? "#" : " "
    }
    str += "\r"
}
print("Day_10_1:")
print(str)

print("Day_10_2: \(seconds)")
