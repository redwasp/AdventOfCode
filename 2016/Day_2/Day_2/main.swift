//
//  main.swift
//  Day2
//
//  Created by Pavlo Liashenko on 26.07.2022.
//

import Foundation
import AdventOfCodeStarterPack

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL)
let lines = inputFileData
    .trimmingCharacters(in: .whitespacesAndNewlines)
    .components(separatedBy: .newlines)
    .map{
        $0.map{
            Direction($0)!
        }
    }

var pos = 5
var code = 0
for line in lines {
    for step in line {
        switch step {
        case .left:
            pos -= pos % 3 == 1 ? 0 : 1
        case .up:
            pos -= pos < 4 ? 0 : 3
        case .right:
            pos += pos % 3 == 0 ? 0 : 1
        case .down:
            pos += pos > 6 ? 0 : 3
        default: break
        }
    }
    code *= 10
    code += pos
}
print("Day_2_1: \(code)")//84452

let keypadStr = """
#######
###1###
##234##
#56789#
##ABC##
###D###
#######
"""
let keypad : [[Character]] = keypadStr.components(separatedBy:.newlines).map{$0.map{$0}}

var location = Position(1, 3)
var code2 = ""
for line in lines {
    for step in line {
        let nLocation = location + step
        if keypad[nLocation] != "#" {
            location = nLocation
        }
        
    }
    code2 += "\(keypad[location])"
}

print("Day_2_2: \(code2)")//D65C3
