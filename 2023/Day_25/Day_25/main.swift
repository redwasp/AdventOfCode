//
//  main.swift
//  Day_25
//
//  Created by Pavlo Liashenko on 25.12.2023.
//

import Foundation

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL).trimmingCharacters(in: .whitespacesAndNewlines)
var lines = inputFileData.components(separatedBy:.newlines)
var connections: [Int: Set<Int>] = [:]
var map: [String: Int] = [:]
var index = 0

func map(_ key: String) -> Int {
    if let index = map[key] {
        return index
    } else {
        map[key] = index
        index += 1
        return index - 1
    }
}

for line in lines {
    let comps = line.components(separatedBy:": ")
    let component = map(comps[0])
    let connected = comps[1].components(separatedBy:" ").map{map($0)}

    if connections[component] == nil {
        connections[component] = []
    }
    connections[component]!.formUnion(connected)
    for component2 in connected {
        if connections[component2] == nil {
            connections[component2] = []
        }
        connections[component2]!.insert(component)
    }
}

var field: [[Int]] = Array(repeating: Array(repeating: 0, count: connections.keys.count), count: connections.keys.count)
var max = 0;
var maxIndexFrom = 0;
var maxIndexTo = 0;

for index in 0..<connections.count {
    var keys = [index]
    var set  = Set(0..<connections.count)
    set.subtract(keys)
    var length = 1
    while set.count > 0 {
        var newKeys : Set<Int> = []
        for key in keys {
            newKeys.formUnion(connections[key]!)
        }
        newKeys.formIntersection(set)
        for newIndex in newKeys {
            field[index][newIndex] = length
            field[newIndex][index] = length
            if length >= max {
                max = length
                maxIndexFrom = index
                maxIndexTo = newIndex
            }
        }
        set.subtract(newKeys)
        keys = Array(newKeys)
        length += 1
    }
}

var set = Set(0..<connections.count)
var groups : [Set<Int>] = [[maxIndexFrom], [maxIndexTo]]
set.remove(maxIndexFrom)
set.remove(maxIndexTo)
while set.count > 0  {
    for index in 0..<2 {
        var newKeys : Set<Int> = []
        for key in groups[index] {
            newKeys.formUnion(connections[key]!)
        }
        newKeys.formIntersection(set)
        groups[index].formUnion(newKeys)
        set.subtract(newKeys)
    }
}

var exit = true
repeat {
    exit = true
    for index in 0..<2 {
        for key in groups[index] {
            let connections = connections[key]!
            let relations1 = connections.subtracting(groups[index])
            if relations1.count > 0 {
                let relations2 = connections.subtracting(groups[(index+1)%2])
                if (relations1.count > relations2.count) {
                    groups[index].remove(key)
                    groups[(index+1)%2].insert(key)
                    exit = false
                    break;
                }
            }
        }
        guard !exit else {break}
    }
} while !exit
print("Day_25: \(groups[0].count * groups[1].count)")//555856
