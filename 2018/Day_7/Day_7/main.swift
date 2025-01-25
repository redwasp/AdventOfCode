//
//  main.swift
//  Day_7
//
//  Created by Pavlo Liashenko on 13.01.2023.
//

import Foundation

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL, encoding: .utf8).trimmingCharacters(in: .whitespacesAndNewlines)
let lines = inputFileData.components(separatedBy:.newlines)
let map = lines.reduce(into: [Character : Set<Character>]()) {
    let words = $1.components(separatedBy: .whitespaces)
    let b = words[7].first!
    let a = words[1].first!
    if $0[b] == nil {
        $0[b] = []
    }
    $0[b]!.insert(a)
    if $0[a] == nil {
        $0[a] = []
    }
}

var items = map.sorted {$0.key < $1.key}
var order : [Character] = []
while items.count != 0 {
    let completed = items.first {$0.value.count == 0}!.key
    order.append(completed)
    items = items.compactMap() {
        guard $0.key != completed else {return nil}
        var set = $0.value
        set.remove(completed)
        return ($0.key, set)
    }
}
let result = String(order)
print("Day_7_1: \(result)")

var alpha = "abcdefghijklmnopqrstuvwxyz".uppercased().enumerated().reduce(into: [Character:Int]()) {
    $0[$1.element] = $1.offset+1
}
var workers : [Character: Int] = [:]
items = map.sorted {$0.key < $1.key}
var time = 0
order = []
while items.count != 0 || workers.count != 0  {
    workers = workers.filter({
        if time == $0.value {
            let key = $0.key
            order.append(key)
            items = items.compactMap() {
                var set = $0.value
                set.remove(key)
                return ($0.key, set)
            }
            return false
        }
        return true
    })
    if workers.count < 5,
       let completed = items.first(where: {$0.value.count == 0}) {
        let key = completed.key
        workers[key] = time + 60 + alpha[key]!
        items = items.filter {$0.key != key}
    } else {
        time += 1
    }
}
print("Day_7_2: \(time-1)")


