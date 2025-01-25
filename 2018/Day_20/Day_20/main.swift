//
//  main.swift
//  Day_20
//
//  Created by Pavlo Liashenko on 23.01.2023.
//

import Foundation

var data = try! String(contentsOf: URL(fileURLWithPath:"input.txt")).trimmingCharacters(in: .newlines);
data.removeFirst()
data.removeLast()

var array : [Any] = []
var stack : [Any] = []
var string : String = ""
for char in data {
    switch char {
    case "(":
        stack.append(array)
        let container : [Any] = []
        stack.append(container)
        array = []
        break
    case ")":
        var parent = stack.popLast() as! [Any]
        parent.append(Array(array))
        array = stack.popLast() as! [Any]
        array.append(parent)
        break
    case "|":
        var parent = stack.popLast() as! [Any]
        parent.append(Array(array))
        stack.append(parent)
        array = []
        break
    default:
        array.append(char)
        break
    }
}

var field : [[Int]] = Array(repeating: Array(repeating: 0, count: 1000), count: 1000)
var max = 0

func fill(xl:Int, yl:Int, a : [Any]) {
    var x = xl
    var y = yl
    var len = field[y][x]
    for item in a {
        len = field[y][x] + 1
        if let char = item as? Character {
            switch char {
            case "E":
                x += 1
                break
            case "W":
                x -= 1
                break
            case "N":
                y -= 1
            case "S":
                y += 1
            default:
                break
            }
            if (field[y][x] == 0 ) {
                field[y][x] = len
            } else if field[y][x] < len {
                len = field[y][x]
            } else {
                field[y][x] = len
            }
            if (field[y][x] > max) {
                max = field[y][x]
            }
        } else if let array = item as? Array<Any> {
            for v in array {
                if let vi = v as? Array<Any> {
                    fill(xl:x, yl:y, a:vi)
                }
            }
        }
    }
}
fill(xl: 500, yl: 500, a: array)
print("Day_20_1:", max);
var count = 0
for row in field {
    for room in row {
        if (room >= 1000) {
            count += 1
        }
    }
}
print("Day_20_2:", count);
