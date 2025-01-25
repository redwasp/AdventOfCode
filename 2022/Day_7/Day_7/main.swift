//
//  main.swift
//  Day_7
//
//  Created by Pavlo Liashenko on 13.12.2022.
//

import Foundation

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL).trimmingCharacters(in: .whitespacesAndNewlines)
var lines = inputFileData.components(separatedBy:"\n")
let root = Item("/")
var current = root

class Item {
    var name: String
    var size: Int?
    var childs: [String: Item] = [:]
    var parent: Item?
    init(_ name: String, size: Int? = nil, parent: Item? = nil) {
        self.name = name
        self.parent = parent
        self.size = size
    }
}

for line in lines {
    let comp = line.components(separatedBy: .whitespaces)
    if comp[0] == "$" {
        if comp[1] == "cd" {
            switch comp[2] {
            case "/":
                current = root
            case "..":
                current = current.parent!
            default:
                current = current.childs[comp[2]] ?? Item(comp[2], parent: current)
            }
        }
    } else if (current.childs[comp[1]] == nil) {
        if comp[0] == "dir" {
            current.childs[comp[1]] = Item(comp[1], parent: current)
        } else {
            current.childs[comp[1]] = Item(comp[1], size:Int(comp[0]), parent: current)
        }
    }
}

func size(_ item: Item) -> Int {
    if (item.size == nil) {
        item.size = item.childs.reduce(into: 0, {$0 += size($1.value)})
    }
    return item.size!
}

var total = size(root)

func size100000(_ item: Item) -> Int {
    guard item.childs.count != 0 else {return 0} // if dir
    var sum = item.size! < 100000 ? item.size! : 0
    sum += item.childs.reduce(into: 0, {$0 += size100000($1.value) })
    return sum
}

print("Day_7_1: \(size100000(root))")

var min = Int.max
var need = 30000000 - (70000000 - total)
func process(_ item: Item) {
    guard item.childs.count != 0 else {return} // if dir
    if item.size! >= need && min > item.size! {
        min = item.size!
    }
    for child in item.childs.values {
        process(child)
    }
}
process(root)

print("Day_7_2: \(min)")

