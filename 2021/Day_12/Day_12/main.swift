//
//  main.swift
//  Day_12
//
//  Created by Pavlo Liashenko on 13.12.2021.
//

import Foundation

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL).trimmingCharacters(in: .whitespacesAndNewlines)
var connections = inputFileData.components(separatedBy:.newlines).map{$0.components(separatedBy:"-")}.reduce(into: Dictionary<String, [String]>()) {
    if $0[$1[0]] == nil {
        $0[$1[0]] = []
    }
    $0[$1[0]]?.append($1[1])
    
    if $0[$1[1]] == nil {
        $0[$1[1]] = []
    }
    $0[$1[1]]?.append($1[0])
}

var count = 0
func process(_ connections : [String : [String]], _ position : String) {
    if position == "end" {
        count += 1
        return
    }
    guard let paths = connections[position] else {return}
    var connections = connections
    if position == position.lowercased() {
        connections.removeValue(forKey: position)
    }
    for path in paths {
        process(connections, path)
    }
}

process(connections, "start")
print("Day_12_1: \(count)")


count = 0
func process2(_ connections : [String : [String]], _ position : String, _ used : Set<String>, _ canUse: Bool) {
    if position == "end" {
        count += 1
        return
    }
    guard let paths = connections[position] else {return}
    var used = used
    var canUse = canUse
    if position == position.lowercased() {
        if used.contains(position) {
            if !canUse {
                return
            }
            canUse = false
        } else {
            used.insert(position)
        }
    }
    for path in paths {
        if path == "start" {continue}
        process2(connections, path, used, canUse)
    }
}

process2(connections, "start", [], true)
print("Day_12_2: \(count)")
