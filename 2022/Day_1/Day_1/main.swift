//
//  main.swift
//  Day_1
//
//  Created by Pavlo Liashenko on 01.12.2022.
//

import Foundation

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL).trimmingCharacters(in: .whitespacesAndNewlines)
var elfs = inputFileData
           .components(separatedBy:"\n\n")
           .map {
               $0.components(separatedBy: .newlines)
               .map {
                   Int($0)!
               }
           }

let callories = elfs.map{$0.reduce(0, +)}.sorted()

let max = callories.last!
print("Day1_1: \(max)")

let max3 = callories.suffix(3).reduce(0, +)
print("Day1_2: \(max3)")
