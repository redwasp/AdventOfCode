//
//  main.swift
//  Day_19
//
//  Created by Pavlo Liashenko on 25.08.2022.
//

import Foundation

var count = 3004953
var last  = count

var set : [Bool] = Array(repeating: true, count: count)
var pos  = 1
var skip = false
while last != 1 {
    if set[pos] {
       if !skip {
           set[pos] = false
           skip = true
           last -= 1
           //print("\(pos) -")
       } else {
           skip = false
           //print("\(pos) +")
       }
    } else {
        //print("\(pos) #")
    }
    pos += 1
    if pos == count {
        pos = 0
    }
}

var index = 0
while !set[index] {
    index += 1
}
print("Day_19_1: \(index+1)")

set  = Array(repeating: true, count: count)
pos  = 0
last = count
var opposite = last/2 - 1
index = 0
while last != 1 {
    if set[pos] {
        repeat {
            opposite += 1
            if opposite == count {
                opposite = 0
            }
        } while !set[opposite]
        set[opposite] = false
        last -= 1
        if last % 2 == 0 {
            repeat {
                opposite += 1
                if opposite == count {
                    opposite = 0
                }
            } while !set[opposite]
        }
    }
    pos += 1
    if pos == count {
        pos = 0
    }
}

index = 0
while !set[index] {
    index += 1
}

print("Day_19_2: \(index+1)")
