//
//  main.swift
//  Day_4
//
//  Created by Pavlo Liashenko on 10.09.2022.
//

import Foundation

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL)
var lines = inputFileData.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy:.newlines)
var valids1 = 0
var valids2 = 0

for line in lines {
    let words = line.split(separator: " ")
    let wordsSet1 = Set(words)
    if wordsSet1.count == words.count {
        valids1 += 1
    }
    let wordsSet2 = Set(words.map{$0.sorted()})
    if wordsSet2.count == words.count {
        valids2 += 1
    }
    
}
print("Day_4_1: \(valids1)")
print("Day_4_2: \(valids2)")
