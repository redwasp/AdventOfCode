//
//  main.swift
//  Day_9
//
//  Created by Pavlo Liashenko on 01.06.2022.
//

import Foundation

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL)
let lines = inputFileData.split(separator: "\n", omittingEmptySubsequences: true)
var distances : [String: [String: Int]] = [:]
var cities : Set<String> = []
for line in lines {
    let parts = line.components(separatedBy:" = ")
    let distance = Int(parts[1])!
    let path = parts[0].components(separatedBy: " to ")
    let from = path[0]
    let to   = path[1]
    if distances[from] == nil {
        distances[from] = [:]
    }
    if distances[to] == nil {
        distances[to] = [:]
    }
    distances[from]![to] = distance
    distances[to]![from] = distance
    cities.insert(from)
    cities.insert(to)
}

let count = cities.count

var minLength = Int.max
var maxLength = 0

func find(_ length: Int, _ current: String, _ remains: Set<String>) {
    if remains.count == 0 {
        if length < minLength {
            minLength = length
        }
        if length > maxLength {
            maxLength = length
        }
    } else {
        for city in remains {
            let distance = distances[current]![city]!
            var newRemains = remains
            newRemains.remove(city)
            find(length+distance, city, newRemains)
        }
    }
}

for startCity in cities {
    var newRemains = cities
    newRemains.remove(startCity)
    find(0, startCity, newRemains)
}

print("Day_9_1: \(minLength)")
print("Day_9_2: \(maxLength)")
