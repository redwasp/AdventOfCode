//
//  main.swift
//  Day_21
//
//  Created by Pavlo Liashenko on 22.12.2024.
//

import Foundation
import AdventOfCodeStarterPack

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL, encoding: .utf8).trimmingCharacters(in: .whitespacesAndNewlines)
var lines = inputFileData.components(separatedBy:.newlines)

var nKeypad : [[Character]]
            = [["7","8","9"],
               ["4","5","6"],
               ["1","2","3"],
               [" ","0","A"]]

var aKeypad : [[Character]]
            = [[" ","^","A"],
               ["<","v",">"]]

var aMap : [Character: [Character: [[Character]]]] = [:]

for y1 in aKeypad.indices {
    for x1 in aKeypad[y1].indices {
        let n = aKeypad[y1][x1]
        guard n != " " else { continue }
        aMap[n] = [n: [["A"]]]
        for y2 in aKeypad.indices {
            for x2 in aKeypad[y2].indices {
                let m = aKeypad[y2][x2]
                guard m != " " else { continue }
                guard x1 != x2 || y1 != y2 else { continue }
                let dx = x1 - x2
                let dy = y1 - y2
                var path:[Character] = []
                if dy > 0 {
                    if dx > 0 {
                        path.append(contentsOf: Array(repeating: "<", count: dx))
                    } else {
                        path.append(contentsOf: Array(repeating: ">", count: -dx))
                    }
                    path.append(contentsOf: Array(repeating: "^", count: dy))

                    if (y2 != 0 || x1 != 0) && abs(dx) > 0 {
                        var path2 :[Character] = []
                        if dx > 0 {
                            path2.append(contentsOf: Array(repeating: "^", count: dy))
                            path2.append(contentsOf: Array(repeating: "<", count: dx))
                        } else {
                            path2.append(contentsOf: Array(repeating: "^", count: dy))
                            path2.append(contentsOf: Array(repeating: ">", count: -dx))
                        }
                        path2.append("A")
                        aMap[n, default:[:]][m, default: []].append(path2)
                    }
                } else {
                    if dx > 0 {
                        path.append(contentsOf: Array(repeating: "v", count: -dy))
                        path.append(contentsOf: Array(repeating: "<", count:  dx))
                    } else {
                        path.append(contentsOf: Array(repeating: "v", count: -dy))
                        path.append(contentsOf: Array(repeating: ">", count: -dx))
                    }
                    if (y1 != 0 || x2 != 0) && abs(dy) > 0 && abs(dx) > 0 {
                        var path2 :[Character] = []
                        if dx > 0 {
                            path2.append(contentsOf: Array(repeating: "<", count: dx))
                            path2.append(contentsOf: Array(repeating: "v", count: -dy))
                        } else {
                            path2.append(contentsOf: Array(repeating: ">", count: -dx))
                            path2.append(contentsOf: Array(repeating: "v", count: -dy))
                        }
                        path2.append("A")
                        aMap[n, default:[:]][m, default: []].append(path2)
                    }
                }
                path.append("A")
                aMap[n, default:[:]][m, default: []].append(path)
            }
        }
    }
}

var nMap : [Character: [Character: [[Character]]]] = [:]
for y1 in nKeypad.indices {
    for x1 in nKeypad[y1].indices {
        let n = nKeypad[y1][x1]
        guard n != " " else { continue }
        nMap[n] = [n: [["A"]]]
        for y2 in nKeypad.indices {
            for x2 in nKeypad[y2].indices {
                let m = nKeypad[y2][x2]
                guard m != " " else { continue }
                guard (x1 != x2 || y1 != y2) else { continue }
                let dx = x1 - x2
                let dy = y1 - y2
                var path:[Character] = []
                if dy > 0 {
                        path.append(contentsOf: Array(repeating: "^", count: dy))
                        if dx > 0 {
                            path.append(contentsOf: Array(repeating: "<", count: dx))
                        } else {
                            path.append(contentsOf: Array(repeating: ">", count: -dx))
                        }
                        if (y1 != 3 || x2 != 0) && abs(dx) > 0 {
                            var path2 : [Character] = []
                            if dx > 0 {
                                path2.append(contentsOf: Array(repeating: "<", count: dx))
                            } else {
                                path2.append(contentsOf: Array(repeating: ">", count: -dx))
                            }
                            path2.append(contentsOf: Array(repeating: "^", count: dy))
                            path2.append("A")
                            nMap[n, default:[:]][m, default: []].append(path2)
                        }
                } else {
                    if dx > 0 {
                        path.append(contentsOf: Array(repeating: "<", count: dx))
                    } else {
                        path.append(contentsOf: Array(repeating: ">", count: -dx))
                    }
                    path.append(contentsOf: Array(repeating: "v", count: -dy))
                    if (y2 != 3 || x1 != 0) && abs(dy) > 0 && abs(dx) > 0 {
                        var path2 : [Character] = []
                        path2.append(contentsOf: Array(repeating: "v", count: -dy))
                        if dx > 0 {
                            path2.append(contentsOf: Array(repeating: "<", count: dx))
                        } else {
                            path2.append(contentsOf: Array(repeating: ">", count: -dx))
                        }
                        path2.append("A")
                        nMap[n, default:[:]][m, default: []].append(path2)
                    }
                }
                path.append("A")
                nMap[n, default:[:]][m, default: []].append(path)
            }
        }
    }
}

var cache = Array(repeating:[Character : [Character: Int]](), count: 28)
func solve(_ robotsChain: Int) -> Int {
    var sum = 0
    for line in lines {
        var prev: Character = "A"
        var length = 0
        for char in line {
            length += count(robotsChain + 1, prev, char, analog: false)
            prev = char
        }
        sum += Int(line.dropLast(1))! * length
    }
    return sum
}

func count(_ steps: Int, _ from: Character,  _ to: Character, analog: Bool = true)-> Int {
    if from == to {return 1}
    guard steps > 0 else {return 1}
    if let result = cache[steps][from, default: [:]][to] {return result}
    let parts = analog ? aMap[from]![to]! : nMap[from]![to]!
    var m = Int.max
    for part in parts {
        var prev: Character = "A"
        var x = 0
        for char in part {
            x += count(steps - 1, prev, char)
            prev = char
        }
        m = min(m, x)
    }
    cache[steps][from, default: [:]][to] = m
    return m
}

print("Day_21_1:", solve(2))//215374
print("Day_21_2:", solve(25))//260586897262600
