//
//  main.swift
//  Day_22
//
//  Created by Pavlo Liashenko on 02.09.2022.
//

import Foundation

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL)
var lines = inputFileData.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines).suffix(from: 2)

struct Item : CustomStringConvertible, Hashable {
    let x: Int
    let y: Int
    let size: Int
    var used: Int
    var avail: Int
    //let use: Int
    var target = false
    
    init(_ string: String) {
        let parts = string.split(separator: " ", omittingEmptySubsequences: true)
        let point = parts[0].split(separator:"-")[1...2].map{Int($0.dropFirst())!}
        x = point[0]
        y = point[1]
        size = Int(parts[1].dropLast())!
        used = Int(parts[2].dropLast())!
        avail = Int(parts[3].dropLast())!
       // use = Int(parts[4].dropLast())!
    }
    
    init() {
        x = 0
        y = 0
        size = 0
        used = 0
        avail = 0
        //use = 0
    }
    
    var description: String {
        "x:\(x) y:\(y) \(size)T \(used)T \(avail)T"
    }
}

struct SmallItem : Hashable{
    let size: Int
    var used: Int
    var avail: Int {size-used}
    var target = false
    init(_ item: Item) {
        self.size = item.size
        self.used = item.used
        self.target = item.target
    }
    init() {
        self.size = 0
        self.used = 0
    }
}

let items = lines.map{Item($0)}
let availItems = items.sorted{$0.avail > $1.avail}
print("\(availItems.count)")

var count = 0
for A in items {
    guard A.used != 0 else {continue}
    for B in availItems {
        guard !(A.x == B.x && A.y == B.y) else {continue}
        if B.avail < A.used {break}
        count += 1
    }
}
print("Day_22_1: \(count)")

var width  = items.map{$0.x}.max()! + 1
var height = items.map{$0.y}.max()! + 1

var mm : [[Bool]] = Array(repeating: Array(repeating: true, count: width), count: height)
var zX = 0
var zY = 0
for item in items {
    mm[item.y][item.x] = item.size <= 100
    if item.used == 0 {
        zY = item.y
        zX = item.x
    }
    if item.y == 0 && item.x == width-1 {
        print("Target: \(item)")
    }
}
var ss = ""
for y in 0..<height {
    for x in 0..<width {
        if x == zX && y == zY {
            ss += "*"
        } else {
            ss += mm[y][x] ? "." : "#"
        }
        
    }
    ss += "\r"
}
print("\(ss)")


typealias ItemMap = [[SmallItem]]

var state : ItemMap = Array(repeating: Array(repeating: SmallItem(), count: width), count: height)

for item in items {
    state[item.y][item.x] = SmallItem(item)
}
state[0][width-1].target = true

//
//var dx = [1, -1, 0, 0]
//var dy = [0,  0, 1, -1]
//
//ss = ""
//for aY in 0..<height {
//    for aX in 0..<width {
//        var count = 0
//        for index in 0..<4 {
//            var A = state[aY][aX]
//            let x = aX + dx[index]
//            guard x >= 0 && x < width else {continue}
//            let y = aY + dy[index]
//            guard y >= 0 && y < height else {continue}
//            var B = state[y][x]
//            if B.size >= A.used {
//                count += 1
//            }
//        }
//        ss += "\(count)"
//    }
//    ss += "\r"
//}
//print("\(ss)")

struct Point {
    let x : Int
    let y : Int
}

var dx = [1, -1, 0, 0]
var dy = [0,  0, 1, -1]

func move(from: Point, to: Point) -> Int {
    var map: [[Int]] = Array(repeating: Array(repeating: 0, count: width), count: height)
    map[from.y][from.x]  = -1
    var points : [Point] = [from]
    var step = 0
    while map[to.y][to.x] == 0 && points.count > 0 {
        step += 1
        var newPoints : [Point] = []
        for point in points {
            let A = state[point.y][point.x]
            for index in 0..<4 {
                let x = point.x + dx[index]
                guard x >= 0 && x < width else {continue}
                let y = point.y + dy[index]
                guard y >= 0 && y < height else {continue}
                guard map[y][x] == 0 else {continue}
                let B = state[y][x]
                guard !B.target  else {continue}
                guard A.size > B.used else {continue}
                map[y][x] = step
                newPoints.append(Point(x: x,y: y))
            }
        }
        points = newPoints
    }
    
    var ss = ""
    for y in 0..<height {
        for x in 0..<width {
            if x == from.x && y == from.y {
                ss += "*"
            } else
            if x == to.x && y == to.y {
                ss += "#"
            } else {
                ss += (map[y][x] < 10 ? "0" : "")  + "\(map[y][x])"
            }
        }
        ss += "\r"
    }
    print("\(ss)")
    return map[to.y][to.x]

}

var len = move(from: Point(x: zX, y: zY), to: Point(x: width-2, y: 0)) + (width - 2)*5 + 1
print("count: \(len)")


//
//var queue : [ItemMap] = [state]
//var nQueue : [ItemMap] = []
//var used : Set<ItemMap> = []
//var step = 0
//

//
//while queue.count != 0 {
//    step += 1
//    print("--------")
//    print("\(step) \(queue.count)")
//    nQueue = []
//    for state in queue {
//        for aY in 0..<height {
//            for aX in 0..<width {
//                guard state[aY][aX].used > 0 else {continue}
//                for index in 0..<4 {
//                    var A = state[aY][aX]
//                    let x = aX + dx[index]
//                    guard x >= 0 && x < width else {continue}
//                    let y = aY + dy[index]
//                    guard y >= 0 && y < height else {continue}
//                    var B = state[y][x]
//                    if B.avail >= A.used {
////                        if A.target {
////                            print("!!! \(A) -> (\(B))")
////                        }
////                        print("(\(A.x),\(A.y)) -> (\(x),\(y))")
////
////                        print("\(A) -> (\(B))")
////                        print("(\(A.x),\(A.y)) -> (\(x),\(y))")
//
//                        B.used += A.used
//                        B.target = B.target || A.target
//                        A.target = false
//                        A.used = 0
//                        var nState = state
//                        nState[y][x] = B
//                        nState[aY][aX] = A
//                        if B.target == true && x == 0 && y == 0 {
//                            print("Day_22_2: \(step)")
//                        }
//
//                        if !used.contains(nState) {
//                            used.insert(nState)
//                            nQueue.append(nState)
//                        }
//                    }
//                }
//            }
//        }
//    }
//    queue = nQueue
//}
//
