//
//  main.swift
//  Day_18
//
//  Created by Pavlo Liashenko on 23.01.2023.
//

import Foundation

extension Array {
    subscript (safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
}

let data = try! String(contentsOf: URL(fileURLWithPath:"input.txt"))
let lines = data.split(separator: "\n" )
var field = lines.map { (s) -> [Int] in
    return s.map({ (c) -> Int in
        switch c {
        case ".":
            return 0
        case "|":
            return 1
        case "#":
            return 2
        default:
            return 0
        }
    })
}
let nx = [0,1,1,1,0,-1,-1,-1]
let ny = [-1,-1,0,1,1,1,0,-1]
let fd = field

var lc = 0
var tc = 0
for y in 0..<field.count {
    let row = field[y]
    for x in 0..<row.count {
        let item = row[x]
        if item == 2 {
            lc+=1;
        }
        if item == 1 {
            tc+=1;
        }
    }
}

var hashes: [Int: Int] = [field.hashValue: 0]
var values: [Int] = [tc*lc]
var minute = 1
var offset = 0
var size   = 0
while true {
    var newField = fd
    for y in 0..<field.count {
        let row = field[y]
        for x in 0..<row.count {
            let item = row[x]
            newField[y][x] = item
            switch item {
            case 0:
                var treeCount = 0
                for i in 0...7 {
                    if field[safe: y+ny[i]]?[safe: x+nx[i]] == 1 {
                        treeCount+=1;
                    }
                }
                if (treeCount >= 3) {
                    newField[y][x] = 1
                    tc+=1
                }
                break;
            case 1:
                var lumberyardCount = 0
                for i in 0...7 {
                    if field[safe: y+ny[i]]?[safe: x+nx[i]] == 2 {
                        lumberyardCount+=1;
                    }
                }
                if (lumberyardCount >= 3) {
                    newField[y][x] = 2
                    tc-=1
                    lc+=1
                }
                break;
            case 2:
                var lumberyardCount = 0
                var treeCount = 0
                for i in 0...7 {
                    if field[safe: y+ny[i]]?[safe: x+nx[i]] == 2 {
                        lumberyardCount+=1;
                    }
                    if field[safe: y+ny[i]]?[safe: x+nx[i]] == 1 {
                        treeCount+=1;
                    }
                }
                if (lumberyardCount == 0 || treeCount == 0) {
                    newField[y][x] = 0
                    lc-=1
                }
                break;
            default:
                break
            }
        }
    }
    field = newField
    let fh = field.hashValue
    if let pair = hashes[fh] {
        offset = pair
        size   = minute - offset
        break
    } else {
        hashes[fh] = minute
        values.append(tc*lc)
    }
    minute += 1
}

func result(munute: Int) -> Int {
    let index = munute < values.count ? munute : ((munute-offset)%size + offset)
    return values[index]
}

print("Day_18_1:",result(munute: 10))
print("Day_18_2:",result(munute: 1000000000))

