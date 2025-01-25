//
//  main.swift
//  Day_17
//
//  Created by Pavlo Liashenko on 15.09.2022.
//

import Foundation

var input = 337
var buffer = [0]
var position = 0
var steps = 2017
for i in 1...steps {
    position = (position + input) % i + 1
    buffer.insert(i, at: position)
}

print("Day_17_1: \(buffer[position+1])")

var first = 0
position = 0
steps = 50000000
for i in 1...steps {
    position = (position + input) % i + 1
    if position == 1 {
        first = i
    }
}
print("Day_17_2: \(first)")

