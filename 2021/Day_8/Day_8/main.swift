//
//  main.swift
//  Day_8
//
//  Created by Pavlo Liashenko on 08.12.2021.
//

import Foundation

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL).trimmingCharacters(in: .whitespacesAndNewlines)
var lines = inputFileData.components(separatedBy:.newlines).map{$0.components(separatedBy:" | ").map{$0.components(separatedBy:" ").map{Set<Character>($0)}}}
var count = 0
for line in lines {
    for item in line[1] {
        let size = item.count
        switch size {
        case 2,3,4,7:
            count += 1
        default:
            break
        }
    }
}
print("Day_8_1: \(count)")//512

var sum = 0
for line in lines {
    var input = line[0]
    input.sort{ $0.count < $1.count}
    var dict : [Set<Character> : Int] = [:]
    dict[input[0]] = 1
    dict[input[1]] = 7
    dict[input[2]] = 4
    dict[input[9]] = 8
    var input5 = input.filter{$0.count == 5}
    let x3 = input5.filter{$0.isSuperset(of: input[0])}.first!
    input5.removeAll {$0 == x3}
    dict[x3] = 3
    let marker5 = input[2].subtracting(input[0])
    let x5 = input5.filter{$0.isSuperset(of: marker5)}.first!
    input5.removeAll {$0 == x5}
    dict[x5] = 5
    let x2 = input5.first!
    dict[x2] = 2
    
    var input6 = input.filter{$0.count == 6}
    let x9 = input6.filter{$0.isSuperset(of: x3)}.first!
    input6.removeAll {$0 == x9}
    dict[x9] = 9
    let x6 = input6.filter{$0.isSuperset(of: x5)}.first!
    input6.removeAll {$0 == x6}
    dict[x6] = 6
    
    let x0 = input6.first!
    dict[x0] = 0

    var number = 0
    for digt in line[1] {
        number *= 10
        number += dict[digt]!
    }
    sum += number
}

print("Day_8_2: \(sum)")//1091165
