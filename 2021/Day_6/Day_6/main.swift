//
//  main.swift
//  Day6
//
//  Created by Pavlo Liashenko on 06.12.2021.
//

import Foundation

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL).trimmingCharacters(in: .whitespacesAndNewlines)
var fishes = inputFileData.components(separatedBy:",").compactMap{Int($0)}
var days   = 80

var cache : [Int : [Int: Int]] = [:]
for day in 0...256 {
    cache[day] = [:]
}

func fpd(_ fish : Int, _ day : Int) -> Int { //fish per day
    if let count = cache[day]![fish] {
        return count
    } else {
        var res : Int!
        if day <= fish {
            res = 1
        } else {
            res = fpd(7, day-fish) + fpd(9, day-fish)
        }
        cache[day]![fish] = res
        return res
    }
}
var result = fishes.reduce(0) {$0 + fpd($1, days)}
print("Day_6_1: \(result)")//346063

days   = 256
result = fishes.reduce(0) {$0 + fpd($1, days)}
print("Day_6_2: \(result)")//1572358335990
