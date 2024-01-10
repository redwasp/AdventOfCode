//
//  main.swift
//  Day_13
//
//  Created by Pavlo Liashenko on 27.06.2022.
//

import Foundation

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL)
let lines = inputFileData.split(separator: "\n", omittingEmptySubsequences: true).map{$0.dropLast()}

var graph = lines.map{$0.components(separatedBy: .whitespaces)}.reduce(into: [String : [String : Int]]()) {
    let value = Int($1[3])!*($1[2] == "gain" ? 1 : -1)
    if $0[$1.first!] == nil {$0[$1.first!] = [:]}
    $0[$1.first!]![$1.last!] = value
}
var names : [String] = Array(graph.keys)

var max = 0
func find (_ names: [String], _ rest: [String]) {
    if rest.count == 0 {
        var sum = 0
        let count = names.count
        for index in 0..<count {
            sum += graph[names[index]]![names[(index+1)%count]]! + graph[names[(index+1)%count]]![names[index]]!
        }
        if sum > max {
            max = sum
        }
    } else {
        for (index, name) in rest.enumerated() {
            var newNames = names
            var newRest = rest
            newRest.remove(at: index)
            newNames.append(name)
            find(newNames, newRest)
        }
    }
}
find([], names)
print("Day_13_1: \(max)")


graph["I"]=[:]
for name in names {
    graph["I"]![name] = 0
    graph[name]!["I"] = 0
}
names.append("I")
max = 0
find([], names)
print("Day_13_2: \(max)")

