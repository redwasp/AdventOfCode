//
//  main.swift
//  Day_16
//
//  Created by Pavlo Liashenko on 15.06.2022.
//

import Foundation

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL)
let aunts = inputFileData.split(separator: "\n", omittingEmptySubsequences: true).map {
    $0[$0.range(of:":")!.upperBound..<$0.endIndex].components(separatedBy:",").map {
        $0.trimmingCharacters(in: .whitespaces).components(separatedBy:": ")
    }.reduce(into: [String: Int]()) {
        $0[$1[0]]=Int($1[1])!
    }
}

let finger = ["children": 3,
              "cats": 7,
              "samoyeds": 2,
              "pomeranians": 3,
              "akitas": 0,
              "vizslas": 0,
              "goldfish": 5,
              "trees": 3,
              "cars": 2,
              "perfumes": 1]

for (index, aunt) in aunts.enumerated() {
    var valid = true
    for (key, value) in aunt {
        if finger[key] != value {
            valid = false
            break
        }
    }
    if valid {
        print("Day_16_1: \(index + 1)")
        break
    }
}

//Part #2
for (index, aunt) in aunts.enumerated() {
    var valid = true
    for (key, value) in aunt {
        let fvalue = finger[key]!
        switch key {
            case "cats", "trees":
                valid = fvalue < value
            case "pomeranians", "goldfish":
                valid = fvalue > value
            default:
                valid = fvalue == value
            
        }
        if !valid {break}
    }
    if valid {
        print("Day_16_2: \(index + 1)")
        break
    }
}
