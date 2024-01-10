//
//  main.swift
//  Day_10
//
//  Created by Pavlo Liashenko on 02.06.2022.
//

import Foundation

var sequence = "1113122113".map{Int8(String($0))!}

var count : Int8 = 1
var newSequence : [Int8] =  []
var char = sequence.first!

//TODO : Optimize

for step in 1...50 {
    count = 1
    newSequence = []
    char = sequence.first!
    for i in 1..<sequence.count {
        if char != sequence[i] {
            newSequence.append(count)
            newSequence.append(char)
            count = 1
            char = sequence[i]
        } else {
            count += 1
        }
    }
    newSequence.append(count)
    newSequence.append(char)
    sequence = newSequence
    if step == 40 {
        print("Day_10_1: \(sequence.count)")//40 = 360154
    }
}

print("Day_10_2: \(sequence.count)")//50 = 5103798
