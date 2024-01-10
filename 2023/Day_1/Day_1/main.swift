//
//  main.swift
//  Day_1
//
//  Created by Pavlo Liashenko on 01.12.2023.
//

import Foundation

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL).trimmingCharacters(in: .whitespacesAndNewlines)
var result = inputFileData
    .components(separatedBy:.newlines)
    .map {
        let numbers = $0.compactMap{$0.wholeNumberValue}
        return numbers.first! * 10 + numbers.last!
    }
    .reduce(0, +);
    

print("Day_1_1: \(result)")

let digits : [String : Int] = [
    "one"  : 1,
    "two"  : 2,
    "three": 3,
    "four" : 4,
    "five" : 5,
    "six"  : 6,
    "seven": 7,
    "eight": 8,
    "nine" : 9
]

var result2 = inputFileData
    .components(separatedBy:.newlines)
    .map {
        var numbers : [Int] = []
        var str = $0
        while str.count > 0 {
            if let number = str.first!.wholeNumberValue {
                numbers.append(number)
            } else {
                for (key, value) in digits {
                    if str.hasPrefix(key) {
                        numbers.append(value)
                        break;
                    }
                }
            }
            str.removeFirst()
        }
        return numbers.first! * 10 + numbers.last!
    }
    .reduce(0, +);

print("Day_1_2: \(result2)")
