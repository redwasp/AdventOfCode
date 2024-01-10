//
//  main.swift
//  Day_19
//
//  Created by Pavlo Liashenko on 19.12.2021.
//

import Foundation

//extension Array : Comparable where Element == Int {
//    public static func < (lhs: Array<Element>, rhs: Array<Element>) -> Bool {
//        for i in 0..<Swift.min(lhs.count, rhs.count) {
//            if lhs[i] == rhs[i] {continue}
//            return lhs[i] < rhs[i]
//        }
//        return lhs.count < rhs.count
//    }
//}

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL).trimmingCharacters(in: .whitespacesAndNewlines)
let blocks = inputFileData.components(separatedBy: "\n\n").map{Array($0.components(separatedBy:.newlines)[1...].map{$0.components(separatedBy: ",").map{Int($0)!}})}
print("\(blocks)")

let rot = [1, -1]
var vectors : [[Int]] = []
for x in rot {
    for y in rot {
        for z in rot {
            vectors.append([x, y, z])
        }
    }
}

var positions : [[Int]] = [[0,1,2],
                           [0,2,1],
                           [1,0,2],
                           [1,2,0],
                           [2,0,1],
                           [2,1,0]]

var offsets : [[Int]] = []

func sub(_ left: [[Int]], _ right: [[Int]]) -> [[Int]]? {
    var newPoint : [Int] = [0,0,0]
    for vector in vectors {
        for p in positions { //x,y,z
            var newPoints : [[Int]] = []
            for point in right {
                newPoint[p[0]] = point[0]*vector[0]
                newPoint[p[1]] = point[1]*vector[1]
                newPoint[p[2]] = point[2]*vector[2]
                newPoints.append(newPoint)
            }
            var map : [[Int]:Int] = [:]
            for lPoint in left {
                for rPoint in newPoints {
                    var offset : [Int] = []
                    for i in 0..<3 {
                        offset.append(rPoint[i] - lPoint[i])
                    }
                    if map[offset] == nil {
                        map[offset] = 1
                    } else {
                        map[offset]! += 1
                    }
                }
            }

            if map.values.contains(where: {$0>=12}) {
                let offset = map.max{$0.value < $1.value}!.key
                newPoints = newPoints.map { [$0[0]-offset[0],
                                 $0[1]-offset[1],
                                 $0[2]-offset[2]]
                }
                offsets.append(offset)
                return newPoints
            }
        }
    }
    return nil
}

var unused = blocks
var normalized : [[[Int]]] = []
normalized.append(unused.removeFirst())
var full = Set<[Int]>(normalized.first!)
var pos = 0
while unused.count != 0 {
    print("---\(pos):(\(unused.count))---")
    let lBlock = Array(full)
    var newUnused : [[[Int]]] = []
    for rBlock in unused {
        if let newBlock = sub(lBlock, rBlock) {
            normalized.append(newBlock)
            full.formUnion(newBlock)
        } else {
            newUnused.append(rBlock)
        }
    }
    pos += 1
    unused = newUnused
}
let superset = normalized.reduce(into: Set<[Int]>()) {$0.formUnion($1)}

print("Day_19_1:\(superset.count)")

print("Offsets:\(offsets)")

func distance(_ x: [Int], _ y: [Int]) -> Int {
    var d = 0
    for i in 0..<3 {
        d += abs(x[i] - y[i])
    }
    return d
}
var max = 0
for x in offsets {
    for y in offsets {
        if x != y {
            let d = distance(x, y)
            if d > max {
                max = d
            }
        }
    }
}
print("Day_19_2:\(max)")
