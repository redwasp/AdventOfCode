//
//  main.swift
//  Day_4
//
//  Created by Pavlo Liashenko on 04.12.2023.
//

import Foundation

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL).trimmingCharacters(in: .whitespacesAndNewlines)
let wins = inputFileData
    .components(separatedBy: .newlines)
    .map {
        $0.components(separatedBy:":")[1]
          .components(separatedBy:"|")
          .map {
            Set($0.components(separatedBy:.whitespaces)
                  .compactMap {
                    Int($0)
                  }
            )
          }
    }.map {
        $0[0].intersection($0[1])
             .count
    }
let result = wins.reduce(0) {
        $0 + 1<<($1 - 1)
}
print("Day_4_1: \(result)")//25571

var cards : [Int] = Array(repeating: 1, count: wins.count)
for index in 0..<cards.count {
    let value = cards[index]
    let count = wins[index]
    guard count != 0 else {continue}
    for j in (index+1)...(index+count) {
        cards[j] += value
    }
}
let result2 = cards.reduce(0, +)
print("Day_4_2: \(result2)")//8805731
