//
//  main.swift
//  Day_9
//
//  Created by Pavlo Liashenko on 09.12.2024.
//

import Foundation

let inputFileURL  = URL(fileURLWithPath: "input1.txt")
let inputFileData = try! String(contentsOf: inputFileURL, encoding: .utf8).trimmingCharacters(in: .whitespacesAndNewlines)
let diskMapData = inputFileData.map{Int(String($0))!}
var diskMap = diskMapData
var (l, r) = (0,diskMap.count-1)
var (li, ri) = (0, diskMap.count/2)
var pos = 0
var result = 0
while l < r || diskMap[l] != 0 {
    result += check(&pos, diskMap[l], li)
    diskMap[l] = 0
    l += 1
    while diskMap[l] > 0 {
        if (diskMap[l] >= diskMap[r]) {
            result += check(&pos, diskMap[r], ri)
            diskMap[l] -= diskMap[r]
            diskMap[r] = 0
            diskMap[r-1] = 0
            r -= 2
            ri -= 1
        } else {
            result += check(&pos, diskMap[l], ri)
            diskMap[r] -= diskMap[l]
            diskMap[l] = 0
        }
    }
    l += 1
    li += 1
}

func check(_ pos: inout Int, _ count: Int, _ id: Int) -> Int {
    var sum = 0
    for pos in pos ..< pos+count {
        sum += pos*id
        //print("\(pos*id) = \(pos)*\(id)")
    }
    pos += count
    return sum
}

print("Day_9_1: \(result)")//6216544403458

diskMap = diskMapData
var files: [(pos: Int, size: Int)] = []
var frees: [(pos: Int, size: Int)] = []

var index = 0
pos = 0
for (index, size) in diskMap.enumerated() {
    if index % 2 == 0 {
        files.append((pos,size))
    } else {
        frees.append((pos,size))
    }
    pos += size
}
var result2 = 0
for (index, var file) in files.enumerated().reversed() {
    for fIndex in 0..<index {
        var free = frees[fIndex]
        if free.size >= file.size {
            file.pos = free.pos
            free.pos += file.size
            free.size -= file.size
            frees[fIndex] = free
            break
        }
    }
    result2 += check(&file.pos, file.size, index)
}
print("Day_9_2: \(result2)")
