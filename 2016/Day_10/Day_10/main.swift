//
//  main.swift
//  Day_10
//
//  Created by Pavlo Liashenko on 10.08.2022.
//

import Foundation

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL)
var lines = inputFileData.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines)

enum Target {
    case bot(Int)
    case output(Int)
}

struct Instruction {
    let low  : Target
    let high : Target
}

class Bot : CustomStringConvertible {
    var chips : [Int] = []
    var description: String {
        "\(chips)"
    }
}

var instructions : [Int: Instruction] = [:]
var bots : [Int: Bot] = [:]

for line in lines {
    let parts = line.components(separatedBy:.whitespaces)
    if parts[0] == "value" {
        let value = Int(parts[1])!
        let botId = Int(parts.last!)!
        if bots[botId] == nil {
            bots[botId] = Bot()
        }
        let bot = bots[botId]!
        bot.chips.append(value)
    } else {
        let botId = Int(parts[1])!
        let lowValue = Int(parts[6])!
        let highValue = Int(parts[11])!
        let low : Target  = parts[5]  == "bot" ? .bot(lowValue)  : .output(lowValue)
        let high : Target = parts[10] == "bot" ? .bot(highValue) : .output(highValue)
        instructions[botId] = Instruction(low: low, high: high)
    }
}

var outputs : [Int: [Int]] = [:]

var exit = false
while !exit {
    exit = true
    for (botId, bot) in bots {
        if bot.chips.count == 2 {
            exit = false
            
            var low  : Int!
            var high : Int!
            if bot.chips[0] < bot.chips[1] {
                low  = bot.chips[0]
                high = bot.chips[1]
            } else {
                low  = bot.chips[1]
                high = bot.chips[0]
            }
            if low == 17 && high == 61 {
                print("Day_10_1: \(botId)")//141
            }
            let instruction = instructions[botId]!
            switch instruction.low {
            case .bot(let botId):
                if bots[botId] == nil {
                    bots[botId] = Bot()
                }
                bots[botId]!.chips.append(low)
            case .output(let outputId):
                outputs[outputId, default: []].append(low)
            }
            
            switch instruction.high {
            case .bot(let botId):
                if bots[botId] == nil {
                    bots[botId] = Bot()
                }
                bots[botId]!.chips.append(high)
            case .output(let outputId):
                outputs[outputId, default: []].append(high)
            }
            bot.chips = []
        }
    }
}
let result2 =  (0...2).map{outputs[$0]!.first!}.reduce(1, *)
print("Day_10_2: \(result2)")//1209
