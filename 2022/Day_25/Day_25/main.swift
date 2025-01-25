//
//  main.swift
//  Day_25
//
//  Created by Pavlo Liashenko on 25.12.2022.
//

import Foundation

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL).trimmingCharacters(in: .whitespacesAndNewlines)
var lines   = inputFileData.components(separatedBy:.newlines).map{$0.map{
    switch $0 {
    case "=":
        return -2
    case "-":
        return -1
    default:
        return $0.wholeNumberValue!
    }
}}

func number(_ dight: [Int]) -> Int {
    var sum = 0
    var d = 1
    for n in dight.reversed() {
        sum += n*d
        d*=5
    }
    return sum
}

func digits(_ number: Int) -> [Int] {
    var x = number
    var dight : [Int] = []
    while x != 0 {
        let y = x % 5
        dight.append(y)
        x /= 5
    }
    var i = 0
    while i < dight.count {
        if dight[i] > 2 {
            dight[i] -= 5
            if dight.count == i+1 {
                dight.append(0)
            }
            dight[i+1] += 1
        }
        i += 1
    }
    return dight.reversed()
}

func number5(_ dights: [Int]) -> String {
    var str = ""
    for dight in dights {
        switch dight {
        case -1:
            str += "-"
        case -2:
            str += "="
        default:
            str += "\(dight)"
        }
    }
    return str
}

let sum = lines.map{number($0)}.reduce(0,+)
print("Day_25: \(number5(digits(sum)))")//2=--=0000-1-0-=1=0=2
