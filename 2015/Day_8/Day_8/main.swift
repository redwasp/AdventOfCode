//
//  main.swift
//  Day_8
//
//  Created by Pavlo Liashenko on 07.06.2022.
//

import Foundation

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL)
let lines = inputFileData.split(separator: "\n", omittingEmptySubsequences: true)
var sizeX = 0
var sizeY = 0
var sizeZ = 0
for line in lines {
    var str = line
    str.removeFirst()
    str.removeLast()
    var index = str.startIndex
    while index != str.endIndex {
        if str[index] == "\\" {
            let next = str[str.index(after:index)]
            if next == "\\" || next == "\"" {
                str.remove(at:index)
            } else if next == "x" {
                str.remove(at:index)
                str.remove(at:index)
                let range = index...str.index(after:index)
                let value = UInt8(str[range], radix: 16)!
                let char  = Character(UnicodeScalar(value))
                str.replaceSubrange(range, with:"\(char)")
            }
            //print("\(str)")
        }
        index = str.index(after: index)
    }
    sizeX += line.count
    sizeY += str.count
    //print("\(line) => \(str)")
    
    // part#2
    str = line
    index = str.startIndex
    while index != str.endIndex {
        let char = str[index]
        var offset = 1
        switch char {
        case "\"", "\\":
            str.insert("\\", at: index)
            offset = 2
        default:
            break;
        }
        index = str.index(index, offsetBy: offset)
    }
    str.insert("\"", at: str.startIndex)
    str.insert("\"", at: str.endIndex)
    sizeZ += str.count
    //print("| \(line) => \(str)")

}

print("Day_8_1: \(sizeX - sizeY)")
print("Day_8_2: \(sizeZ - sizeX)")
