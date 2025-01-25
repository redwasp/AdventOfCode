//
//  main.swift
//  Day_20
//
//  Created by Pavlo Liashenko on 20.12.2022.
//

import Foundation

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL).trimmingCharacters(in: .whitespacesAndNewlines)
var numbers = inputFileData.components(separatedBy:.newlines).map{Int($0)!}
var zerroID = numbers.firstIndex(of: 0)!
var count = numbers.count
var indexes = Array(0..<count)
var step = 0
var newIndexes = indexes
for index in indexes {
    let offset = numbers[index]
    let current = newIndexes.firstIndex(of:index)!
    var new = (current + offset) % (count - 1)
    if new < 0 {
        new += count - 1
    }
    newIndexes.remove(at: current)
    newIndexes.insert(index, at: new)
    step += 1
}

var i1 = (newIndexes.firstIndex(of: zerroID)! + 1000) % (count)
var i2 = (newIndexes.firstIndex(of: zerroID)! + 2000) % (count)
var i3 = (newIndexes.firstIndex(of: zerroID)! + 3000) % (count)

print("Day20_1: \(numbers[newIndexes[i1]] + numbers[newIndexes[i2]] + numbers[newIndexes[i3]])")//2215//7225
 
let newNumbers = numbers.map{$0*811589153}
newIndexes = indexes
for _ in 0..<10 {
    for index in indexes {
        let offset = newNumbers[index]
        let current = newIndexes.firstIndex(of:index)!
        var new = (current + offset) % (count - 1)
        if new < 0 {
            new += count - 1
        }
        newIndexes.remove(at: current)
        newIndexes.insert(index, at: new)
    }
}
i1 = (newIndexes.firstIndex(of: zerroID)! + 1000) % (count)
i2 = (newIndexes.firstIndex(of: zerroID)! + 2000) % (count)
i3 = (newIndexes.firstIndex(of: zerroID)! + 3000) % (count)

print("Day20_2: \(newNumbers[newIndexes[i1]] + newNumbers[newIndexes[i2]] + newNumbers[newIndexes[i3]])")//8927480683//548634267428
