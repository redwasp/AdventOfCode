//
//  main.swift
//  Day_21
//
//  Created by Pavlo Liashenko on 23.12.2022.
//

import Foundation

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL).trimmingCharacters(in: .whitespacesAndNewlines)
var data = inputFileData.components(separatedBy:.newlines).map{$0.components(separatedBy:": ").map{$0.components(separatedBy: .whitespaces)}}.reduce(into: [String:[String]]()) { $0[$1[0][0]] = $1[1]}
var cache : [String: Int] = [:]

func value(_ name: String) -> Int {
    if let value = cache[name] {return value}
    let parts = data[name]!
    var res = 0
    if  parts.count == 1 {
        res = Int(parts[0])!
    } else {
        switch parts[1] {
        case "+":
            res = value(parts[0]) + value(parts[2])
        case "-":
            res = value(parts[0]) - value(parts[2])
        case "*":
            res = value(parts[0]) * value(parts[2])
        case "/":
            res = value(parts[0]) / value(parts[2])
        default:
            break
        }
    }
    cache[name] = res
    return res
}

print("Day_21_1: \(value("root"))")//232974643455000


func chain(_ test: String) -> [String] {
    for (name, value) in data {
        guard value.count == 3 else {continue}
        if value[0] == test || value[2] == test {
            var childs = chain(name)
            childs.append(name)
            return childs
        }
    }
   return []
}

var path = chain("humn")
let droot = data["root"]!
let aname = droot[0]
let bname = droot[2]
data["root"]![1] = "="
var value = 0

while path.count > 0 {
    let item = path.removeFirst()
    let parts = data[item]!
    let next = path.first ?? "humn"
    let i = parts[0] == next ? 2 : 0
    let arg = parts[i]
    let argValue = value(arg)
    switch parts[1] {
    case "+":
        value -= argValue
    case "-":
        value = i == 2 ? (value + argValue) : (argValue - value)
    case "*":
        value /= argValue
    case "/":
        value = i == 2 ? (value * argValue) : (argValue / value)
    case "=":
        value = argValue
    default: break
    }
}
print("Day_21_2: \(value)")//3740214169961
