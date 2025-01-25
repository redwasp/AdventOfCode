//
//  main.swift
//  Day_16
//
//  Created by Pavlo Liashenko on 14.09.2022.
//

import Foundation

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL)
let input = inputFileData.trimmingCharacters(in: .whitespacesAndNewlines)
let moves = input.split(separator: ",")

var programsS = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q"]

func process(_ steps: Int) -> String {
    var programs : [Int] = Array(0..<16)
    for index in 0..<steps {
        let move = moves[index%moves.count]
        switch move.first! {
        case "s":
            let offset = programs.count - Int(String(move[move.index(after:move.startIndex)...]))!
            programs =  Array(programs[offset...]) + Array(programs[..<offset])
        case "x":
            let indexes = String(move[move.index(after:move.startIndex)...]).split(separator: "/").map {return Int($0)!}
            let tmp = programs[indexes[0]]
            programs[indexes[0]] = programs[indexes[1]]
            programs[indexes[1]] = tmp
        case "p":
            let indexes = String(move[move.index(after:move.startIndex)...]).split(separator: "/").map { programs.firstIndex(of:programsS.firstIndex(of:String($0))!)!}
            let tmp = programs[indexes[0]]
            programs[indexes[0]] = programs[indexes[1]]
            programs[indexes[1]] = tmp
        default:
            break
        }
    }
    var res = ""
    for program in programs {
        res += programsS[program]
    }
    return res
}

print("Day_16_1: \(process(moves.count))")
print("Day_16_2: \(process(1000000000))")
