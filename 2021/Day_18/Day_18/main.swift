//
//  main.swift
//  Day_18
//
//  Created by Pavlo Liashenko on 18.12.2021.
//

import Foundation

class Item : CustomStringConvertible, Equatable {
    
    static func == (lhs: Item, rhs: Item) -> Bool {
        lhs.value == rhs.value && lhs.left == rhs.left && lhs.right == rhs.right
    }
    
    var value : Int?
    var left  : Item?
    var right : Item?
    init(_ left: Item, _ right: Item) {
        self.left = left
        self.right = right
    }
    
    init(_ left: Int, _ right: Int) {
        self.left = Item(left)
        self.right = Item(right)
    }
    
    init(_ value: Int) {
        self.value = value
    }
    
    var description: String {
        if value != nil {
            return "\(value!)"
        } else {
            return "["+left!.description + "," + right!.description+"]"
        }
    }
    
    func copy() -> Item {
        if value != nil {
            return Item(value!)
        } else {
            return Item(left!.copy(), right!.copy())
        }
    }
}

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL).trimmingCharacters(in: .whitespacesAndNewlines)
let lines = inputFileData.components(separatedBy: .newlines)

func parse(_ srt: String) -> Item {
    var stack : [Item] = []
    for char in srt {
        switch char {
        case ",","[":
            continue
        case "]":
            let second = stack.removeLast()
            let first  = stack.removeLast()
            stack.append(Item(first, second))
        default:
            stack.append(Item(Int(String(char))!))
        }
    }
    if stack.count > 1 {
        print("Error:\(stack.count)")
    }
    return stack.last!
}
var prev : Item?
func reduce(_ item: Item, _ depth: Int, _ rightPart: inout Int?, _ end: inout Bool) -> Item {
    if end {
        return item
    }
    if item.value != nil {
        if rightPart != nil {
            let item = item
            item.value! += rightPart!
            rightPart = nil
            end = true
            return item
        }
        prev = item
        return prev!
    } else {

        if depth >= 4 && rightPart == nil && !end && item.left!.value != nil && item.right!.value != nil {
            if prev != nil {
                prev!.value! += item.left!.value!
            }
            rightPart = item.right!.value!
            return Item(0)
        } else {
            let left  = reduce(item.left!, depth+1, &rightPart, &end)
            let right = reduce(item.right!, depth+1, &rightPart, &end)
            return Item(left, right)
        }
    }
}

func split(_ item: Item, _ end: inout Bool) -> Item {
    if end {
        return item
    }
    if let value = item.value {
        if value > 9 {
            let left = value/2
            let right = value-left
            end = true
            return Item(left, right)
        } else {
            return item
        }
    }  else {
        let left  = split(item.left!, &end)
        let right = split(item.right!, &end)
        return Item(left, right)
    }
}

func reduce(_ item: Item) -> Item {
    var item = item.copy()
    var exit = false
    while !exit {
        exit = true
        var end = false
        var right : Int? = nil
        prev = nil
        item = reduce(item, 0, &right, &end)
        exit = right == nil && !end
        if exit {
            end = false
            item = split(item, &end)
            exit = !end
        }
    }
    return item
}

func add(_ left: Item, _ right: Item) -> Item {
   let item = Item(left.copy(), right.copy())
   return reduce(item)
}

var items = lines.map{parse($0)}
var sum : Item = items.removeFirst()
for item in items {
    sum = add(sum, item)
}

func magnitude(_ item: Item) -> Int {
    if item.value == nil {
        return 3*magnitude(item.left!) + 2*magnitude(item.right!)
    } else {
        return item.value!
    }
}

let result = magnitude(sum)
print("Day18_1: \(result)")

items = lines.map{parse($0)}
var max = 0
for lItem in items {
    for rItem in items {
        if (lItem != rItem) {
            let sum = add(lItem, rItem)
            let m = magnitude(sum)
            if m > max {
                max = m
            }
        }
    }
}
print("Day18_2: \(max)");
