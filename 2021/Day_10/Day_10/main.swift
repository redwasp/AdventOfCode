//
//  main.swift
//  Day_10
//
//  Created by Pavlo Liashenko on 10.12.2021.
//

import Foundation

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL).trimmingCharacters(in: .whitespacesAndNewlines)
var lines = inputFileData.components(separatedBy:.newlines)
var brackets : [Character : Character] = ["(":")",
                                          "[":"]",
                                          "{":"}",
                                          "<":">"];
var points : [Character : Int] = [")":3,
                                  "]":57,
                                  "}":1197,
                                  ">":25137];

var points2 : [Character : Int] = [")":1,
                                  "]":2,
                                  "}":3,
                                  ">":4];

var opened = Set<Character>(brackets.keys)
var closed = Set<Character>(brackets.values)
var stack : [Character] = []
var sum = 0

var scores: [Int] = []
var score = 0

for line in lines {
    stack = []
    score = 0
    var corrupt = false
    for char in line {
        if opened.contains(char) {
            stack.append(char)
        } else {
            if stack.count == 0 {
                print("Error")
            } else {
                let last = stack.removeLast()
                let closed = brackets[last]
                if (char != closed) {
                    sum += points[char]!
                    corrupt = true
                    continue
                }
            }
        }
    }
    if !corrupt {
        while stack.count != 0 {
            let last = stack.removeLast()
            let closed = brackets[last]!
            score *= 5
            score += points2[closed]!
        }
        scores.append(score)
    }
}

print("Day_10_1: \(sum)")//321237
scores.sort()
//print("\(scores)");
//print("Count = \(scores.count)");
print("Day_10_2: \(scores[scores.count/2])")//2360030859
