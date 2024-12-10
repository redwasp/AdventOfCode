//
//  main.swift
//  Day_25
//
//  Created by Pavlo Liashenko on 07.09.2022.
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
        case out
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
print("\(program)")

let x = 0b101010101010//2541
print("\(x) \(x-231*11)")
var regs : [String: Int] = ["a": x - 231*11] //["a": 7]//



var pos = 0
while pos < program.count {

    var command = program[pos]
    //print("\(command)")

    var offset = 1
    switch command.kind {
    case .out:
        print("\(pos) \(regs)")

        print("----------------")
        print("\((command.args[0] as? Int) ?? regs[command.args[0] as! String]!)")
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
    }
    pos += offset
}
