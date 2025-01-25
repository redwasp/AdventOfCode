//
//  main.swift
//  Day_17
//
//  Created by Pavlo Liashenko on 22.01.2023.
//

import Foundation

let data = try! String(contentsOf: URL(fileURLWithPath:"input.txt"))
let lines = data.split(separator: "\n" )
var field : [[Int]] = Array.init(repeating: Array.init(repeating: 0, count: 2000), count: 2000)
var maxY = 0
var minY = Int.max
for line in lines {
    let items = line.split(separator: ",")
    let isX : Bool = items[0].hasPrefix("x")
    let pos = Int(items[0][items[0].index(items[0].startIndex, offsetBy: 2)..<items[0].endIndex])!
    let range = items[1][items[1].index(items[1].startIndex, offsetBy: 3)..<items[1].endIndex].split(separator: ".").map { (r) -> Int in
        return Int(r)!
    }
    if !isX {
        if pos > maxY {
            maxY = pos
        }
        if pos < minY {
            minY = pos
        }
    } else {
        if range[1] > maxY {
            maxY = range[1]
        }
        if range[0] < minY {
            minY = range[0]
        }
    }
    for i in range[0]...range[1] {
        if isX {
            field[i][pos] = 1
        } else {
            field[pos][i] = 1
        }
    }
}

struct Point {
    var x : Int
    var y : Int
}

extension Point: Hashable {
    static func == (lhs: Point, rhs: Point) -> Bool {
        return lhs.y == rhs.y && lhs.x == rhs.x
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(y*2000+x)
    }
}

var sources : [Point] = [Point.init(x:500,y:minY)]


while sources.count != 0 {
    
    var newSources : Set<Point> = []

    for i in 0..<sources.count {
        let source = sources[i]
        field[source.y][source.x] = -1
        if (source.y >= maxY) {
            continue;
        }
        if field[source.y+1][source.x] <= 0 {
            newSources.insert(Point.init(x:source.x, y:source.y+1))
        } else  {
            //horizont
            var rightX = source.x
            var hasRightRange = true
            var hasLeftRange = true

            while (field[source.y+1][rightX] > 0 && field[source.y][rightX] <= 0) {
                field[source.y][rightX] = -1
                rightX += 1
            }
            if (field[source.y+1][rightX] <= 0 && field[source.y][rightX] <= 0) {//drop down
                newSources.insert(Point.init(x:rightX, y:source.y+1))
                field[source.y][rightX] = -1
                hasRightRange = false
            }
            var leftX = source.x
            while (field[source.y+1][leftX] > 0 && field[source.y][leftX] <= 0) {
                field[source.y][leftX] = -1
                leftX -= 1
            }
            if (field[source.y+1][leftX] <= 0 && field[source.y][leftX] <= 0) {//drop down
                newSources.insert(Point.init(x:leftX, y:source.y+1))
                field[source.y][leftX] = -1
                hasLeftRange = false
            }
            if (hasRightRange && hasLeftRange) {//TODO: fix corners
                //fill
                for x in leftX+1...rightX-1 {
                    field[source.y][x] = 2
                }
                newSources.insert(Point.init(x:source.x, y:source.y-1))
            }
        }
    }
    sources = Array(newSources);
}
//var test = field[0...13].map { (arr) -> [Int] in
//    return Array(arr[494...507])
//}
//for rw in test {
//    print(rw)
//}
var water1 = 0;
var water2 = 0;

for row in field {
    for item in row {
        if item == 2 {
            water1 += 1
        }
        if item == -1 {
            water2 += 1
        }
    }
}
print("Result 1:",water1 + water2)
print("Result 2:",water1 )
