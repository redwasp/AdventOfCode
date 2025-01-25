//
//  main.swift
//  Day_10
//
//  Created by Pavlo Liashenko on 13.09.2022.
//

import Foundation

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL)
var input = inputFileData.trimmingCharacters(in: .whitespacesAndNewlines).split(separator: ",").map{Int($0)!}
var array : [Int] = []
var n = 256
for index in 0..<n {
    array.append(index)
}
var skip = 0
var position = 0
for length in input {

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

print("Day_10_1: \(array[0]*array[1])")

array = []

var values : [Int] = inputFileData.trimmingCharacters(in: .whitespacesAndNewlines).map{Int($0.asciiValue!)}
values.append(contentsOf:[17, 31, 73, 47, 23])

for index in 0..<n {
    array.append(index)
}
skip = 0
position = 0
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
var hash = ""
for i in 0..<16 {
    let val = array[i*16..<i*16+16].reduce(0) { $0^$1 }
    hash += String(format:"%02x",val)
}
print("Day_10_2: \(hash)")
