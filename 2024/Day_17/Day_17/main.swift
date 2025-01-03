//
//  main.swift
//  Day_17
//
//  Created by Pavlo Liashenko on 17.12.2024.
//

import Foundation

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL, encoding: .utf8).trimmingCharacters(in: .whitespacesAndNewlines)
let dataParts = inputFileData.split(separator: "\n\n")
let regs = dataParts[0].split(separator: "\n").map{Int($0.split(separator:": ")[1])!}
let program = dataParts[1].split(separator:": ")[1].components(separatedBy:",").map{Int($0)!}
var (a,b,c) = (regs[0],regs[1],regs[2])
func find(_ a: Int) -> [Int] {
    var a = a
    var pos = 0
    var out : [Int] = []
    while pos < program.count {
        let instruction = program[pos]
        let literal = program[pos+1]
        var combo = 0
        switch literal {
        case 0...3: combo = literal
        case 4: combo = a
        case 5: combo = b
        case 6: combo = c
        default:
            break
        }
        pos += 2
        
        switch instruction {
        case 0:
            a = a / (1<<combo)
        case 1:
            b ^= literal
        case 2:
            b = combo % 8
        case 3:
            if a != 0 { pos = literal }
        case 4:
            b ^= c
        case 5:
            out.append(combo%8)
        case 6:
            b = a / (1<<combo)
        case 7:
            c = a / (1<<combo)
        default:
            break
        }
    }
    return out
}

print("Day_17_1:", find(a).map{String($0)}.joined(separator:","))//6,7,5,2,1,3,5,1,7

a = 8
var result = find(a)
var size = 1
var offsets: [Int] = [1]
while result.count < program.count {
    a <<= 1
    result = find(a)
    if size < result.count {
        offsets.append(a)
        size = result.count
    }
}

result = find(a)

for i in (0..<result.count).reversed() {
    while result[i] != program[i] {
        a += offsets[i]
        result = find(a)
    }
}

while result != program {
    for i in (0..<result.count).reversed() {
        if result[i] != program[i] {
            a += 1<<(2*i)
        }
    }
    result = find(a)
}

print("Day_17_2:", a)
