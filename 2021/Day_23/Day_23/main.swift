//
//  main.swift
//  Day_23
//
//  Created by Pavlo Liashenko on 23.12.2021.
//

import Foundation


let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL).trimmingCharacters(in: .whitespacesAndNewlines)
var lines = inputFileData.components(separatedBy: .newlines)
lines.insert("  #D#C#B#A#", at: 3)
lines.insert("  #D#B#A#C#", at: 4)
let field = lines.map{$0.map{$0}}
pr(field)

func pr(_ field: [[Character]]) {
    let str = field.reduce(""){$0 + $1.reduce(""){$0 + String($1)} + "\n"}
    print(str)
}





struct Point : Hashable, Equatable {
    let x : Int
    let y : Int
    init(_ x : Int, _ y : Int) {
        self.x = x
        self.y = y
    }
}

//struct Amphipod : Hashable {
//    var kind     : Character
//    var position : Point
//
//    init(_ kind : Character, _ position : Point) {
//        self.kind     = kind
//        self.position = position
//    }
//}
var energy : [Character: Int]     = ["A" : 1,
                                     "B" : 10,
                                     "C" : 100,
                                     "D" : 1000]
let rm : [Int: Character] = [3:"A",5:"B",7:"C",9:"D"]
var rooms  : [Character: [Point]] = ["A":[],
                                     "B":[],
                                     "C":[],
                                     "D":[]]
let exits : Set<Point> = [Point(3,1), Point(5,1), Point(7,1), Point(9,1)]

var free      : Set<Point> = []
var wall      : Set<Point> = []
var amphipods : [Point: Character] = [:]

func pra(_ amphipods: [Point: Character]) {
    var str = ""
    for y in 0..<field.count {
        for x in 0..<field[y].count {
            let point = Point(x, y)
            if let a = amphipods[point] {
                str += String(a)
            } else if free.contains(point) {
                str += " "
            } else if wall.contains(point) {
                str += "#"
            }
        }
        str += "\n"
    }
    print(str)
}

for y in 0..<field.count {
    for x in 0..<field[y].count {
        let point = Point(x, y)
        let value = field[y][x]
        switch field[y][x] {
        case ".":
            free.insert(point)
        case " ", "#":
            wall.insert(point)
        default:
            amphipods[point] = value
            rooms[rm[point.x]!]!.append(point)
            free.insert(point)
        }
    }
}


var minEnergy = Int.max;

func complete(_ amphipods: [Point: Character]) -> Bool {
    for (kind, points) in rooms {
        for point in points {
            if (amphipods[point] != kind) {
                return false
            }
        }
    }
    return true
}

func find(_ fullEnergy: Int, _ amphipods: [Point: Character], _ step: Int, _ used: Set<Point>) {
    //used.insert(amphipods.hashValue)
    //pra(amphipods)
    if fullEnergy > minEnergy {return}
    if complete(amphipods) {
        if fullEnergy < minEnergy {
            minEnergy = fullEnergy
            print("\(minEnergy) S:\(step)")
        }
        return
    }
    
    for (position, amphipod) in amphipods {
        if position.y == 1 { // in hallway
            let room = rooms[amphipod]!
            let target = room[0].x
            var posX = position.x
            var energyOffsetX = 0
            let offset = posX < target ? 1 : -1
            var busy = false
            while posX != target && !busy {
                posX += offset
                if amphipods[Point(posX, 1)] != nil {
                    busy = true
                } else {
                    energyOffsetX += energy[amphipod]!
                }
            }
            guard !busy else {continue}
            var posY = 1
            var valid = true
            var validY = 0
            var energyOffsetY = 0
            while valid {
                posY += 1
                if !free.contains(Point(posX, posY)) {
                    break
                }
                let current = amphipods[Point(posX, posY)]
                switch current {
                case nil:
                    validY = posY
                    energyOffsetY += energy[amphipod]!
                case amphipod:
                    break
                default:
                    valid = false
                }
            }
            if valid && validY != 0 {
                var newAmphipod = amphipods
                newAmphipod[position] = nil
                newAmphipod[Point(posX, validY)] = amphipod
                var newUsed = used
                newUsed.insert(Point(posX, validY))
                find(fullEnergy + energyOffsetX + energyOffsetY, newAmphipod, step+1, newUsed)
            }
        } else {
            if used.contains(position) {
                continue
            }
            var inPlase = false
            for room in rooms[amphipod]! {
                if (room == position) {
                    inPlase = true
                } else {
                    if !(amphipods[room] == amphipod || amphipods[room] == nil) {
                        inPlase = false
                        break
                    }
                }
            }
            if inPlase {
                continue
            }
            
            var pos = position.y
            var energyOffsetY = 0
            var busy = false
            while pos > 1 && !busy {
                pos -= 1
                if amphipods[Point(position.x, pos)] != nil {
                    busy = true
                } else {
                    energyOffsetY += energy[amphipod]!
                }
            }
            guard !busy else {continue}
            pos = position.x
            var energyOffsetX = 0
            busy = false
            while pos > 1 && !busy {
                pos -= 1
                if amphipods[Point(pos, 1)] != nil {
                    busy = true
                } else {
                    energyOffsetX += energy[amphipod]!
                    if pos != 3,
                       pos != 5,
                       pos != 7,
                       pos != 9 {
                        var newAmphipod = amphipods
                        newAmphipod[position] = nil
                        newAmphipod[Point(pos, 1)] = amphipod
                        find(fullEnergy + energyOffsetX + energyOffsetY, newAmphipod, step+1, used)
                    }
                }
            }
            
            pos = position.x
            energyOffsetX = 0
            busy = false
            while pos < 11 && !busy {
                pos += 1
                if amphipods[Point(pos, 1)] != nil {
                    busy = true
                } else {
                    energyOffsetX += energy[amphipod]!
                    if pos != 3,
                       pos != 5,
                       pos != 7,
                       pos != 9 {
                        var newAmphipod = amphipods
                        newAmphipod[position] = nil
                        newAmphipod[Point(pos, 1)] = amphipod
                        find(fullEnergy + energyOffsetX + energyOffsetY, newAmphipod, step+1, used)
                    }
                }
            }
        }
    }
}

find(0, amphipods, 0, [])
print("Day_23_1:\(minEnergy)")
