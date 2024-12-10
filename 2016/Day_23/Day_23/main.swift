//
//  main.swift
//  Day_23
//
//  Created by Pavlo Liashenko on 06.09.2022.
//

import Foundation

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL)
var lines = inputFileData.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines)

struct Command: CustomStringConvertible {
    enum Kind: String {
        case cpy
        case dec
        case inc
        case jnz
        case tgl
    }
    var kind : Kind
    let args : [Any]
    
    init(_ str: String) {
        let parts = str.components(separatedBy: .whitespaces)
        self.kind = Kind(rawValue: parts[0])!
        self.args = parts[1...].map {
            return Int($0) ?? String($0) as Any
        }
    }
    
    var description: String {
        "\(kind) \(args)"
    }
}

var program = lines.map{Command($0)}
//print("\(program)")

var regs : [String: Int] = ["a": 12] //["a": 7]//
var pos = 0
while pos < program.count {
    //print("\(pos) \(regs)")

    var command = program[pos]
    //print("\(command)")

    var offset = 1
    switch command.kind {
    case .inc:
        regs[command.args[0] as! String]! += 1
    case .dec:
        regs[command.args[0] as! String]! -= 1
    case .cpy:
        regs[command.args[1] as! String] = (command.args[0] as? Int) ?? regs[command.args[0] as! String]!
    case .jnz:
        let value =  (command.args[0] as? Int) ?? regs[command.args[0] as! String]!
        if value != 0 {
            offset = (value < 0 ? -1 : 1) * ((command.args[1] as? Int) ?? regs[command.args[1] as! String]!)
        }
    case .tgl:
        let index = pos + regs[command.args[0] as! String]!
        print("\(index)")
        print("\(regs)")
        if program.indices.contains(index) {
            var cmd = program[index]
            if cmd.args.count == 1 {
                if cmd.kind == .inc {
                    cmd.kind = .dec
                } else {
                    cmd.kind = .inc
                }
            } else if cmd.args.count == 2 {
                if cmd.kind == .jnz {
                    cmd.kind = .cpy
                } else {
                    cmd.kind = .jnz
                }
            } else {
                print("xxx")
            }
            program[index] = cmd
            print("-----")
            for cmd in program {
                print("\(cmd)")
            }
        }
    }
    pos += offset
}

//1260 low
//479001600 low
//479008560
print("\(regs)")
