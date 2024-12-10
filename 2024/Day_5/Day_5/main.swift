//
//  main.swift
//  Day_5
//
//  Created by Pavlo Liashenko on 05.12.2024.
//

import Foundation

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL, encoding: .utf8).trimmingCharacters(in: .whitespacesAndNewlines)
let parts = inputFileData.split(separator:"\n\n")
let rules = parts[0]
            .components(separatedBy:.newlines)
            .map{$0
                .split(separator:"|")
                .map{Int($0)!}
            }
            .reduce(into:[Int:Set<Int>]()) {
                $0[$1[0], default: []].insert($1[1])
            }
let updates = parts[1]
            .components(separatedBy:.newlines)
            .map {$0
                .split(separator:",")
                .map{Int($0)!}
            }
var result1 = 0
exit: for update in updates {
    var pages: Set<Int> = []
    for page in update {
        if rules[page, default: []].contains(where: {pages.contains($0)}) {
            continue exit
        }
        pages.insert(page)
    }
    result1 += update[update.count/2]
}
print("Day_5_1:", result1)

var result2 = 0
for update in updates {
    var pages: Set<Int> = []
    var wrong = false
    for page in update {
        if rules[page, default: []].contains(where: {pages.contains($0)}) {
            wrong = true
            break
        }
        pages.insert(page)
    }
    if (wrong) {
       let fixed = update.sorted { rules[$0, default: []].contains($1)}
        result2 += fixed[fixed.count/2]
    }
}
print("Day_5_2:", result2)
