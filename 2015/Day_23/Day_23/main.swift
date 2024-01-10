//
//  main.swift
//  Day_23
//
//  Created by Pavlo Liashenko on 23.06.2022.
//

import Foundation

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL)
let lines = inputFileData.split(separator: "\n", omittingEmptySubsequences: true)

let program : [(name: String, args: [String])] = lines.map {
    var index     = $0.index($0.startIndex, offsetBy: 3)
    let command   = String($0[..<index])
    index = $0.index(after: index)
    let arguments = $0[index...].components(separatedBy:", ")
    return (command, arguments)
}


func value(of arguments: [String]) -> Int {
    if arguments.count == 1 {
        if let value = Int(arguments[0]) {
            return value
        } else {
            return regs[arguments[0]]!
        }
    } else {
        return Int(arguments[1])!
    }
}

var regs : [String: Int] = ["a": 0, "b": 0];

func run() -> Int {
var pos = 0
while pos < program.count {
        let command = program[pos]
        let value   = value(of: command.args)
        let reg     = command.args[0]

        switch command.name {
        case "inc":
            regs[reg] = value + 1
            pos += 1
        case "hlf":
            regs[reg] = value / 2
            pos += 1
        case "tpl":
            regs[reg] = value * 3
            pos += 1
        case "jmp":
            pos += value
        case "jie":
            pos += regs[reg]! % 2 == 0 ? value : 1
        case "jio":
            pos += regs[reg] == 1 ? value : 1
        default:
            break
        }
    }
    return regs["b"]!
}

print("Day_23_1:\(run())")

regs = ["a": 1, "b": 0];
print("Day_23_2:\(run())")
