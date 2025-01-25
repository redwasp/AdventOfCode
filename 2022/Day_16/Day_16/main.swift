//
//  main.swift
//  Day_16
//
//  Created by Pavlo Liashenko on 20.12.2022.
//

import Foundation

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL).trimmingCharacters(in: .whitespacesAndNewlines)
var lines = inputFileData.components(separatedBy:.newlines)

var names: [String: Int] = [:]
func nameID(_ name: String) -> Int {
    guard let id = names[name] else {
        let id = names.count
        names[name] = id
        return id
    }
    return id
}

var rel: [Int: [Int]] = [:]
var rates: [Int: Int] = [:]

var index = 0
for line in lines {
    let parts = line.components(separatedBy:";")
    var words = parts[0].components(separatedBy:.whitespaces)
    let valve = words[1]
    let valveID = nameID(valve)
    let rate = Int(words.last!.components(separatedBy:"=").last!)!
    words = parts[1].components(separatedBy:.whitespaces)[5...].map{$0.trimmingCharacters(in:.punctuationCharacters)}
    rel[valveID] = words.map{nameID($0)}
    rates[valveID] = rate
}

func stepRate(_ opened: Set<Int>) -> Int {
    var rate = 0
    for valveID in opened {
        rate += rates[valveID]!
    }
    return rate
}
var idAA = nameID("AA")
var base: [Int] = [idAA]
var matrix: [Int: [Int : Int]] = [:]
for (key, rate) in rates {
    if rate != 0 {
        base.append(key)
    }
}
//base.sort(by: {rates[$0]! > rates[$1]!})

for top1 in base {
    matrix[top1] = [:]
    for top2 in base {
        guard top1 != top2 else {continue}
        var next = [top1]
        var exit = false
        var step = 0
        while !exit {
            step += 1
            var newNext : Set<Int> = []
            for item in next {
                if item == top2 {
                    matrix[top1]![top2] = step
                    exit = true
                    break
                }
                newNext.formUnion(rel[item]!)
            }
            next = Array(newNext)
        }
    }
}

var max = 0
find(0, 30, idAA, 0, 0, [idAA], 1)
print("Day_16_1: \(max)")//1880//1724

max = 0
find(0, 26, idAA, 0, 0, [idAA], 2)
print("Day_16_2: \(max)")//2520//2283


func find(_ step: Int, _ steps: Int, _ position: Int, _ total: Int, _ perMinute: Int, _ opened: Set<Int>, _ count: Int) {
    if step >= steps {
        if count > 1 {
            find(0, steps, idAA, total, 0, opened, count - 1)
        } else {
            if total > max {
                max = total
                //print("\(max)")
            }
        }
        return
    }
    var exit = true
    for item in base {
        guard !opened.contains(item) else {continue}
        guard let min = matrix[position]![item] else {continue}
        guard step+min <= steps else {continue}
        var opened = opened
        opened.insert(item)
        exit = false
        find(step+min, steps, item, total + min*perMinute, perMinute + rates[item]!, opened, count)
    }
    if exit {
        find(steps, steps, position, total + (steps - step)*perMinute, perMinute, opened, count)
    }
}
