//
//  main.swift
//  Day_11
//
//  Created by Pavlo Liashenko on 11.08.2022.
//

import Foundation
let map : [[UInt8]] = [[0, 1, 3, 5, 10, 11, 12, 13],
                       [2, 4],
                       [7, 6, 9, 8],
                       []]


func isCompleted(_ map: [[UInt8]]) -> Bool {
    for i in 0..<map.count-1 {
        if map[i].count != 0 {return false}
    }
    return true
}

func isValid(_ map: [[UInt8]]) -> Bool {
    for floor in map {
        for i in 0..<floor.count {
            if floor[i]%2 == 0 {
                var a = false
                var b = false
                for j in 0..<floor.count {
                    if floor[j]%2 == 1 {
                        if floor[j] != floor[i] + 1 {
                            a = true
                        } else {
                            b = true
                        }
                    }
                }
                if a && !b {
                    return false
                }
            }
        }
    }
    return true
}

struct Item : Hashable {
    var floor : UInt8
    var map   : [[UInt8]]
    
    init(_ floor: UInt8, _ map:  [[UInt8]]) {
        self.floor = floor
        self.map   = map.map{$0.sorted(by: <)}
    }
}

var minStep = Int.max
var stack : [Item] = [Item(0, map)]
var used  : Set<Item> = []

var step = 0
var floorOffset : [Int8] = [-1, 1]
var exit = false
while stack.count != 0 && !exit {
    step += 1
    print("\(step) \(stack.count)");
    var newStack : [Item] = []
    for item in stack {
        let currentFloorIndex = item.floor
        let map   = item.map
        for offset in floorOffset {
            if (currentFloorIndex == 0 && offset == -1) || (currentFloorIndex == 3 && offset == 1) {
                continue
            }
            
            let targetFloorIndex = UInt8(Int8(currentFloorIndex) + offset)

            let currentFloor = map[Int(currentFloorIndex)]

            for index in 0..<currentFloor.count {
                var currentFloor = currentFloor
                var newMap = map
                var newFloor = newMap[Int(targetFloorIndex)]
                let x = currentFloor.remove(at: index)
                newFloor.append(x)
                newMap[Int(targetFloorIndex)]  = newFloor
                newMap[Int(currentFloorIndex)] = currentFloor
                if isCompleted(newMap) {
                    print("Day_11_1: \(step)")
                    exit = true
                    break
                }
                if isValid(newMap) {
                    let item = Item(targetFloorIndex, newMap)
                    if !used.contains(item) {
                        newStack.append(Item(targetFloorIndex, newMap))
                    }
                }
                for j in 0..<currentFloor.count {
                    var currentFloor = currentFloor
                    var newMap = newMap
                    var newFloor = newFloor
                    let x = currentFloor.remove(at: j)
                    newFloor.append(x)
                    newMap[Int(targetFloorIndex)]  = newFloor
                    newMap[Int(currentFloorIndex)] = currentFloor
                    if isCompleted(newMap) {
                        print("Day_11_1: \(step)")
                        exit = true
                        break
                    }
                    if isValid(newMap) {
                        let item = Item(targetFloorIndex, newMap)
                        if !used.contains(item) {
                            newStack.append(Item(targetFloorIndex, newMap))
                        }
                    }
                }
            }
        }
    }
    used.formUnion(stack)
    stack = Array(Set(newStack))
}
