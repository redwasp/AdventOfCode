//
//  main.swift
//  Day_24
//
//  Created by Pavlo Liashenko on 07.09.2022.
//

import Foundation

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL)
var input = inputFileData.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines).map{$0.map{$0}}
var map : [[Bool]] = input.map{$0.map{$0 != "#"}}

struct Point {
    var x : Int
    var y : Int
    init(_ x: Int, _ y: Int) {
        self.x = x
        self.y = y
    }
}




var checkPointsTmp : [Int : Point] = [:]
for y in 0..<input.count {
    let line = input[y]
    for x in 0..<line.count {
        let char = line[x]
        guard let index = char.wholeNumberValue else {continue}
        checkPointsTmp[index] = Point(x,y)
    }
}
var checkPoints : [Point] = []
for i in 0 ..< checkPointsTmp.count {
    checkPoints.append(checkPointsTmp[i]!)
}




var zerroMatrix : [[Int]] = Array(repeating: Array(repeating: -1, count: map[0].count), count: map.count)
var checkPointsMap : [[Int]] = Array(repeating: Array(repeating: -1, count: map[0].count), count: map.count)
for (i, p) in checkPoints.enumerated() {
    checkPointsMap[p.y][p.x] = i
}
var dx = [1, -1, 0, 0]
var dy = [0,  0, 1, -1]

var mm : [[Int]] = Array(repeating: Array(repeating: 0, count: checkPoints.count), count: checkPoints.count)

for (from, p) in checkPoints.enumerated() {
    var matrix = zerroMatrix
    matrix[p.y][p.x] = 0
    var points = [p]
    var step = 0
    while points.count != 0 {
        step += 1
        var nPoints : [Point] = []
        print("\(step) == \(points.count)")
        for point in points {
            for i in 0..<4 {
                var nP = point
                nP.x += dx[i]
                nP.y += dy[i]
                guard map[nP.y][nP.x] else {continue}
                guard matrix[nP.y][nP.x] == -1 else {continue}
                matrix[nP.y][nP.x] = step
                nPoints.append(nP)
                let to = checkPointsMap[nP.y][nP.x]
                guard to >= 0 else {continue}
                mm[from][to] = step
                mm[to][from] = step
            }
        }
        points = nPoints
    }
}

print("\(mm)")

var min = Int.max

func find(_ size: Int, _ pos: Int, _ visited: Set<Int>) {
    if visited.count == mm.count {
        let fs = size + mm[pos][0]
        if fs < min {
            min = fs
        }
    }
    //if size > min {return}
    for i in 0..<mm.count {
        guard i != pos else {continue}
        guard !visited.contains(i) else {continue}
        let nSize = size + mm[pos][i]
        let nPos = i
        var nV = visited
        nV.insert(i)
        find(nSize, nPos, nV)
    }
}

find(0, 0, [0])
print("Day_24_1:\(min)")
