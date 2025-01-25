//
//  main.swift
//  Day_11
//
//  Created by Pavlo Liashenko on 17.12.2022.
//

import Foundation

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL).trimmingCharacters(in: .whitespacesAndNewlines)
var monkeys = inputFileData.components(separatedBy:"\n\n").map{Monkey($0)}
var monkeysStart = monkeys

struct Monkey {
    var items : [Int]
    let operation : (Int) -> Int
    let test  : Int
    let right : Int //If true
    let left  : Int //If false
        
    static func add(_ arg2: Int) -> (Int) -> Int {
        func add(input: Int) -> Int {return input + arg2}
        return add
    }
    
    static func mul(_ arg2: Int) -> (Int) -> Int {
        func mul(input: Int) -> Int {return input * arg2}
        return mul
    }
    
    static func sqrt(_ input: Int) -> Int {
        input * input
    }
    
    static func skip(_ input: Int) -> Int {
        input
    }
    
    static func buildOperation(_ string: String) -> (Int) -> Int {
        let components = string.components(separatedBy:"=")[1].trimmingCharacters(in: .whitespaces).components(separatedBy:" ")
        guard components[0] == "old" else {return skip}
        switch components[1] {
            case "+":
                return add(Int(components[2])!)
            case "*":
                if components[2] == "old" {
                    return sqrt
                } else {
                    return mul(Int(components[2])!)
                }
            default:
                return skip
        }
    }
    
    init(_ string: String) {
        let lines = string.components(separatedBy: .newlines)
        self.items = lines[1].components(separatedBy:":")[1].trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy:",").map{Int($0.trimmingCharacters(in:.whitespaces))!}
        self.operation = Monkey.buildOperation(lines[2])
        self.test = Int(lines[3].components(separatedBy:.whitespaces).last!)!
        self.right = Int(lines[4].components(separatedBy:.whitespaces).last!)!
        self.left = Int(lines[5].components(separatedBy:.whitespaces).last!)!
    }
}


var counts: [Int] = Array(repeating: 0, count: monkeys.count)

for _ in 0..<20 {
    for index in 0..<monkeys.count {
        let monkey = monkeys[index]
        for item in monkey.items {
            let newItem = monkey.operation(item) / 3
            if newItem % monkey.test == 0 {
                monkeys[monkey.right].items.append(newItem)
            } else {
                monkeys[monkey.left].items.append(newItem)
            }
            counts[index] += 1
        }
        monkeys[index].items = []
    }
}
counts.sort(by:>)
print("Day_11_1: \(counts[0]*counts[1])")//55944


//Part #2
monkeys = monkeysStart
var k = monkeys.reduce(into: 1) {$0 *= $1.test}
counts = Array(repeating: 0, count: monkeys.count)

for _ in 0..<10000 {
    for index in 0..<monkeys.count {
        let monkey = monkeys[index]
        for item in monkey.items {
            let newItem = monkey.operation(item) % k
            if newItem % monkey.test == 0 {
                monkeys[monkey.right].items.append(newItem)
            } else {
                monkeys[monkey.left].items.append(newItem)
            }
            counts[index] += 1
        }
        monkeys[index].items = []
    }
}
counts.sort(by:>)
print("Day_11_2: \(counts[0]*counts[1])")//15117269860
