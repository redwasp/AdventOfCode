//
//  main.swift
//  Day_18
//
//  Created by Pavlo Liashenko on 15.09.2022.
//

import Foundation

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL)
let input = inputFileData.trimmingCharacters(in: .whitespacesAndNewlines)
let lines = input.split(separator: "\n")


//var regs : [String : Int] = ["p":0]
//var queue : [Int] = []
//var position = 0
//var data : [[String]] = []
//for line in lines {
//    let words = line.split(separator: " ").map{String($0)}
//    data.append(words)
//}
//var count = 0
//while position < data.count {
//    let words = data[position]
//    let value1 = Int(words[1]) ?? regs[words[1]]
//    let value2 = words.count > 2 ? (Int(words[2]) ?? regs[words[2]]) : 0
////    print("\(program) = \(words)")
////    print(count)
//    switch words[0] {
//    case "set":
//        regs[words[1]] = value2
//        position += 1
//    case "add":
//        regs[words[1], default: 0] += value2!
//        position += 1
//    case "mul":
//        regs[words[1], default : 0] *= value2!
//        position += 1
//    case "mod":
//        regs[words[1], default : 0] %= value2!
//        position += 1
//    case "snd":
//        count += 1
//        print("play: \(value1!)")
//        queue.append(value1!)
//        position += 1
//    case "rcv":
//        if value1 != 0 {
//            print("XXX:\(value1)")
//        } else {
//            print("----")
//        }
//        if queue.count > 0 {
//            regs[words[1]] = queue.first!
//            print("YYY:\(value1)")
//            queue.remove(at: 0)
//            position += 1
//        }
//    case "jgz":
//        if value1! > 0 {
//            position += value2!
//        } else {
//            position += 1
//        }
//    default: break
//    }
//}
//


var regs : [Int: [String : Int]] = [0:["p":0],1:["p":1]]
var queue : [Int : [Int]] = [0:[],1:[]]
var position : [Int : Int] = [0:0, 1:0]
var program = 0
var data : [[String]] = []
for line in lines {
    let words = line.split(separator: " ").map{String($0)}
    data.append(words)
}
var count = 0
while position[program]! < data.count {
    let words = data[position[program]!]
    let value1 = Int(words[1]) ?? regs[program]![words[1]]
    let value2 = words.count > 2 ? (Int(words[2]) ?? regs[program]![words[2]]) : 0
    switch words[0] {
    case "set":
        regs[program]![words[1]] = value2
        position[program]! += 1
    case "add":
        regs[program]![words[1], default: 0] += value2!
        position[program]! += 1
    case "mul":
        regs[program]![words[1], default : 0] *= value2!
        position[program]! += 1
    case "mod":
        regs[program]![words[1], default : 0] %= value2!
        position[program]! += 1
    case "snd":
        if program == 1 {
            count += 1
        }
        queue[(program+1)%2]!.append(value1!)
        position[program]! += 1
    case "rcv":
        if queue[program]!.count > 0 {
            regs[program]![words[1]] = queue[program]!.first
            queue[program]!.remove(at: 0)
            position[program]! += 1
        } else {
            program = (program + 1) % 2
        }
    case "jgz":
        if value1! > 0 {
            position[program]! += value2!
        } else {
            position[program]! += 1
        }
    default: break
    }
}

print(count)
