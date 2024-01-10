//
//  main.swift
//  Day_2
//
//  Created by Pavlo Liashenko on 03.12.2023.
//

import Foundation

enum Color: String {
    case red
    case blue
    case green
}
let maxColors : Dictionary<Color, Int> = [.red : 12, .green: 13, .blue: 14];
let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL)
                         .trimmingCharacters(in: .whitespacesAndNewlines)
let lines = inputFileData.components(separatedBy: .newlines)
var result = 0
for line in lines {
    let parts = line.components(separatedBy:":")
    let gameID = Int(parts[0].components(separatedBy:.whitespaces)[1])!
    let subsets = parts[1].components(separatedBy:";")
    var valid = true
    for subset in subsets {
        let parts = subset.components(separatedBy: ",")
        for part in parts {
            let parts = part.trimmingCharacters(in: .whitespaces).components(separatedBy: .whitespaces)
            let color = Color(rawValue:parts[1])!
            let count = Int(parts[0])!
            if (maxColors[color]! < count) {
                valid = false
                break
            }
        }
        if (!valid) {break}
    }
    if (valid) {
        result += gameID
    }
}
print("Day_2_1:\(result)")

var result2 = 0
for line in lines {
    let parts = line.components(separatedBy:":")
    let subsets = parts[1].components(separatedBy:";")
    var maxSubset : Dictionary<Color, Int> = [:];
    for subset in subsets {
        let parts = subset.components(separatedBy: ",")
        for part in parts {
            let parts = part.trimmingCharacters(in: .whitespaces).components(separatedBy: .whitespaces)
            let color = Color(rawValue: parts[1])!
            let count = Int(parts[0])!
            if let maxColor = maxSubset[color] {
                if maxColor < count {
                    maxSubset[color] = count
                }
            } else {
                maxSubset[color] = count
            }
        }
    }
    result2 += maxSubset.reduce(1){$0 * $1.value}
}
print("Day_2_2:\(result2)")
