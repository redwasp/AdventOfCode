//
//  main.swift
//  Day_24
//
//  Created by Pavlo Liashenko on 24.12.2021.
//

import Foundation

enum Argument : CustomStringConvertible {
    case variable(String)
    case number(Int)
    
    var description: String {
        switch self {
        case .variable(let name):
            return "\(name)"
        case .number(let value):
            return "\(value)"
        }
    }
}

struct Instruction : CustomStringConvertible {
    let command: String
    let arguments: [Argument]
    
    init(_ line: String) {
        var components = line.components(separatedBy:.whitespaces)
        command = components.removeFirst()
        var values : [Argument] = []
        for component in components {
            if let number = Int(component) {
                values.append(.number(number))
            } else {
                values.append(.variable(component))
            }
        }
        arguments = values
    }
    
    var description: String {
        return "\(command)  \(arguments)\n"
    }
    
}

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL).trimmingCharacters(in: .whitespacesAndNewlines)
var instructions = inputFileData.components(separatedBy: .newlines).map{Instruction($0)}
print("\(instructions)")

var number = 999_999_999_999_99
    number = 135_792_468_999_99
    number = 100_000_000_000_00
var min = Int.max

var probe =  16811412161117//42558321537131
           //16811412161117
           //39924989499969
             //
          // //10
//96999498942993
//39924989499969
for g in 0..<140 {
    let index = 1 + g / 10
    var offset = 1
    for _ in 0 ..< index {
        offset *= 10
    }
    let y = probe % (offset/10)
    let x = (probe / offset)
    var number = (x*10 + (1+(g%10)%8)) * (offset/10) + y
    
//    for j in 0..<14 {
//        var x = probe/10
//        number *= 10
//        number += 1 + Int(arc4random())%8
//    }
    //number = 54111287848141
    //         77776113452541
    //         42558321537183 - 328
    //         42558321537141 - 276
    //         42558321537131 - 10
    let start = number
    var n : [Int] = []
    while number != 0 {
        n.append(number%10)
        number /= 10
    }
    
    var vars = ["x" : 0, "y" : 0, "z" : 0, "w" : 0]
    for instruction in instructions {
        var var1 : String = ""
        if case let .variable(name) = instruction.arguments[0] {
            var1 = name
        }
        var value : Int = 0
        if instruction.arguments.count > 1 {
            switch instruction.arguments[1] {
            case .number(let x):
                value = x
            case .variable(let var2):
                value = vars[var2]!
            }
        }
        switch instruction.command {
        case "inp":
            vars[var1] = n.removeLast()
            number /= 10
        case "add":
            vars[var1]! += value
        case "mul":
            vars[var1]! *= value
        case "div":
            vars[var1]! /= value
        case "mod":
            vars[var1]! %= value
            if vars[var1]! < 0 || value < 0 {
                print("Error")
            }
        case "eql":
            vars[var1] = vars[var1] == value ? 1 : 0
        default:
            break
        }
    }
    if min >= vars["z"]! {
        min = vars["z"]!
        print("\(start) - \(vars["z"]!)")
    }


}
