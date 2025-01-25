//
//  main.swift
//  Day_9
//
//  Created by Pavlo Liashenko on 13.09.2022.
//

import Foundation

print("Hello, World!")

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL)
var input = inputFileData.trimmingCharacters(in: .whitespacesAndNewlines)

var stack : [Character] = []
var valueStack : [Int] = [0]
var summ = 0
var skip = false
var summ2 = 0

for char in input {
    if !skip {
        switch char {
        case "!" :
            skip = true
        case "<" :
            if (stack.last != "<") {
                stack.append(char)
            } else {
                summ2 += 1
            }
        case ">" :
            stack.remove(at:stack.count-1)
        case "{" :
            if (stack.last != "<") {
                stack.append(char)
                valueStack.append(1)
            } else {
                summ2 += 1
            }
        case "}" :
            if (stack.last != "<") {
                stack.remove(at:stack.count-1)
                summ += valueStack[valueStack.count-1]
                valueStack[valueStack.count-2] += valueStack.last!
                valueStack.remove(at:valueStack.count-1)
            } else {
                summ2 += 1
            }
        default:
            if (stack.last == "<") {
                summ2 += 1
            }
            break
        }
    } else {
       skip = false
    }
}
print("Day_9_1: \(summ)")
print("Day_9_2: \(summ2)")
