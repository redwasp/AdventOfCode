//
//  main.swift
//  Day_11
//
//  Created by Pavlo Liashenko on 13.09.2022.
//

import Foundation

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL)
var input = inputFileData.trimmingCharacters(in: .whitespacesAndNewlines)
let steps = input.split(separator: ",")
var vec: [String] = ["n","ne","se","s","sw","nw"]
var set: [String: Int] = ["ne":0, "se":0, "nw":0, "sw":0, "n":0, "s":0]
var count = 0
var max = 0
for step in steps {
    set[String(step),default: 0] += 1
    let minwe = min(set["sw"] ?? 0,set["ne"] ?? 0)
    set["sw", default: 0] -= minwe
    set["ne", default: 0] -= minwe
    let minew = min(set["se"] ?? 0,set["nw"] ?? 0)
    set["se", default: 0] -= minew
    set["nw", default: 0] -= minew
    let minsn = min(set["s"] ?? 0,set["n"] ?? 0)
    set["s", default: 0] -= minsn
    set["n", default: 0] -= minsn
    count = 0
    for item in set {
        count += item.value
        let i = (vec.firstIndex(of:item.key)! + 2) % 6
        let key = vec[i]
        count -= min(item.value,set[key]!)
    }
    if (count > max) {
        max = count
    }
}
print("Day_11_1: \(count)")
print("Day_11_2: \(max)")
