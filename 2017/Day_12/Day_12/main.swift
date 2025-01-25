//
//  main.swift
//  Day_12
//
//  Created by Pavlo Liashenko on 13.09.2022.
//

import Foundation

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL)
var input = inputFileData.trimmingCharacters(in: .whitespacesAndNewlines)
let lines = input.split(separator: "\n")
let items : [Int : Set<Int>] = lines.map{$0.components(separatedBy: "<->").map{$0.trimmingCharacters(in: .whitespacesAndNewlines)}}.reduce(into: [Int : Set<Int>]()) { $0[Int($1[0])!] = Set($1[1].components(separatedBy:",").map{Int($0.trimmingCharacters(in: .whitespacesAndNewlines))!})
    }

print("\(items)")

var used : Set<Int> = []
func count(_ item : Int) -> Int {
    guard !used.contains(item) else {return 0}
    used.insert(item)
    var result = 1
    for item in items[item]! {
        result += count(item)
    }
    return result
}
print("Day_12: \(count(0))")

//
var groups : [Set<Int>] = []
var prev = 0
for (index, item) in items {
    var numbers : Set<Int> = Set()
    numbers.insert(index)
    numbers.formUnion(item)
    var toRemove : [Set<Int>] = []
    for group in groups {
        if !numbers.isDisjoint(with:group) {
            numbers = numbers.union(group)
            toRemove.append(group)
        }
    }
    groups.append(numbers)
    for group in toRemove {
        groups.remove(at:groups.firstIndex(of:group)!)
    }
}
print("Day_12: \(groups.count)")

