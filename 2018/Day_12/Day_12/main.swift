//
//  main.swift
//  Day_12
//
//  Created by Pavlo Liashenko on 20.01.2023.
//

import Foundation

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL).trimmingCharacters(in: .whitespacesAndNewlines)
let parts = inputFileData.components(separatedBy:"\n\n")

let start = parts[0].components(separatedBy:.whitespaces).last!.map{$0=="#"}
let map = parts[1].components(separatedBy:.newlines).map{$0.components(separatedBy:" => ")}.map{$0.map{$0.map{$0=="#"}}}.reduce(into: [[Bool]:Bool]()) { $0[$1[0]] = $1[1].last!}

func pr(_ line: [Bool]) {
    print(line.reduce(into:"") { $0 += $1 ? "#":"."})
}

func generate(_ input: [Bool], _ steps: Int) -> [Bool] {
    let offset = steps * 2
    var line = Array(repeating: false, count: offset)
    line.append(contentsOf: input)
    line.append(contentsOf: Array(repeating: false, count: offset))

    for _ in 0..<steps {
        var newLine = line
        for index in 2..<line.count-2  {
            let key = Array(line[(index-2)...(index+2)])
            newLine[index] = map[key] ?? false
        }
        line = newLine
    }
    return line
}

func calc(_ line: [Bool], _ offset: Int) -> Int {
    var sum = 0
    for (index, value) in line.enumerated() {
        if value {
            sum += index - offset
        }
    }
    return sum
}

let line1 = generate(start, 20)
print("Day_12_1: \(calc(line1, 20*2))")
 
let line2 = generate(start, 100)
var sum1 = calc(line2, 100*2)
let line3 = generate(line2, 1)
var sum2 = calc(line3, 101*2)
let ds = sum2 - sum1
let result = sum1 + (50000000000 - 100)*ds
print("Day_12_2: \(result)")
