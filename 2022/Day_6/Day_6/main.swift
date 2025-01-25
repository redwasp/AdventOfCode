//
//  main.swift
//  Day_6
//
//  Created by Pavlo Liashenko on 10.12.2022.
//

import Foundation

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let string = try! String(contentsOf: inputFileURL).trimmingCharacters(in: .newlines)
var done = false
var index = string.startIndex
for i in 0 ..< string.count-4 {
    let set : Set<Character> = Set(string[index..<string.index(index, offsetBy: 4)])
    if set.count == 4 {
        print("Day_6_1: \(i+4)")
        break
    }
    index = string.index(after: index)
}


index = string.startIndex
for i in 0 ..< string.count-4 {
    let set : Set<Character> = Set(string[index..<string.index(index, offsetBy: 14)])
    if set.count == 14 {
        print("Day_6_2: \(i+14)")
        break
    }
    index = string.index(after: index)
}
