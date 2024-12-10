//
//  main.swift
//  Day_12
//
//  Created by Pavlo Liashenko on 11.08.2022.
//

import Foundation

struct Command {
    var name : String
    var args : [String]
    init(_ str: String) {
        let parts = str.components(separatedBy: .whitespaces)
        name = parts[0]
        args = Array(parts[1...])
    }
}

extension Command : CustomStringConvertible {
    var description: String {
        "\(name) \(args)"
    }
}

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL)
let lines = inputFileData.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines)
let script = lines.map{Command($0)}


var old = 0

func process(_ regs : [String : Int]) -> Int {
    var regs : [String : Int] = regs
    func value(of arg: String) -> Int {
        Int(arg) ?? regs[arg] ?? 0
    }
    
    var pos = 0
    while pos < script.count {
        let command = script[pos]
        var offset  = 1
        switch command.name {
        case "cpy":
            regs[command.args[1]] = value(of: command.args[0])
        case "inc":
            regs[command.args[0]] = value(of: command.args[0]) + 1
        case "dec":
            regs[command.args[0]] = value(of: command.args[0]) - 1
        case "jnz":
            if value(of: command.args[0]) > 0 {
                offset = value(of: command.args[1])
            } else if value(of: command.args[0]) < 0 {
                offset = -value(of: command.args[1])
            }
        default:
            break
        }
        pos += offset
    }
    return regs["a"]!
}

print("Day_12_1:\(process([:]))")
print("Day_12_2:\(process(["c":1]))")
