//
//  main.swift
//  Day_14
//
//  Created by Pavlo Liashenko on 14.09.2022.
//

import Foundation

import Foundation

func knohhash(_ input : String) -> [Int] {
    var values:[Int] = []
    for char in input.utf8 {
        values.append(Int(char))
    }
    values.append(contentsOf:[17, 31, 73, 47, 23])

    var array:[Int] = []
    let n = 256
    for i in 0..<n {
        array.append(i)
    }
    
    var skip = 0
    var position = 0
    for _ in 0..<64 {
        for length in values {
            for i in 0..<length/2 {
                let index = (position + i)%array.count
                var indexRevers =  (position + length - i - 1)%array.count
                if indexRevers < 0 {
                    indexRevers += array.count
                }
                
                let tmp = array[index]
                array[index] = array[indexRevers]
                array[indexRevers] = tmp
            }
            position = (position + length + skip)%array.count
            skip += 1
        }
    }
    var hash = [Int]()
    for i in 0..<16 {
        let val = array[i*16..<i*16+16].reduce(0) { $0^$1 }
        hash.append(val)
    }
    return hash
}

var input = "hxtvlmkl"
var hashes = [[Int]]()
var matrix = [[Bool]]()
var matrixUsed = repeatElement(repeatElement(false, count: 128), count:128)

var count = 0
for row in 0...127 {
    let in1 = String(format: "%@-%d",input,row)
    let hash = knohhash(in1)
    hashes.append(hash)
    var rowValue = [Bool]()
    for num in hash {
        for i in 0...7 {
            let bit = (num & (1 <<
                (7-i))) != 0;
            rowValue.append(bit)
        }
    }
    matrix.append(rowValue)
}
var count2 = 0
for i in 0...127 {
    var row = ""
    for j in 0...127 {
        if matrix[i][j] {
            count2 += 1
            row += "1"
        } else {
            row += "0"
        }
    }
    print(row)
}
print("Day_14_1: \(count2)")

func clear(_ i : Int, _ j : Int) {
    if i < 0 || j < 0 || i >= matrix.count || j >= matrix[i].count {
        return
    }
    if matrix[i][j] {
        matrix[i][j] = false
        clear(i-1,j)
        clear(i+1,j)
        clear(i,j-1)
        clear(i,j+1)
    }
}
for i in 0...127 {
    for j in 0...127 {
        if matrix[i][j] {
            count+=1
            clear(i,j)
        }
    }
}

print("Day_14_2: \(count)")
