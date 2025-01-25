//
//  main.swift
//  Day_2
//
//  Created by Pavlo Liashenko on 14.12.2023.
//

import Foundation

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL).trimmingCharacters(in: .whitespacesAndNewlines)
var data = inputFileData.components(separatedBy:",").map{Int($0)!}
  
func running(_ programm: [Int]) -> Int {
    var programm = programm
    var pos = 0
    var opcode = 0
    repeat  {
        opcode = programm[pos]
        if opcode == 1 || opcode == 2 {
            let i = programm[pos+1]
            guard programm.indices.contains(i) else {
                return 0
            }
            let j = programm[pos+2]
            guard programm.indices.contains(j) else {
                return 0
            }
            let a = programm[i]
            let b = programm[j]
            let to = programm[pos+3]
            guard programm.indices.contains(to) else {
                return 0
            }
            if opcode == 1 {
                programm[to] = a + b
            } else if opcode == 2 {
                programm[to] = a * b
            }
            pos += 4
        }
    } while opcode != 99
    return programm[0]
}

print("Day2_1: \(running(data))")

func running2(_ programm: [Int]) -> Int {
    for noun in 12...99 {
        for verb in 2...99 {
            var programm = programm
            programm[1] = noun
            programm[2] = verb
            let result = running(programm)
            if result == 19690720 {
                return 100*noun + verb
            }
        }
    }
    return 0
}

print("Day2_2: \(running2(data))")
