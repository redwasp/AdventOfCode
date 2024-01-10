//
//  main.swift
//  Day_21
//
//  Created by Pavlo Liashenko on 21.12.2021.
//

import Foundation

var pos = [1, 5]
//var pos = [4, 8]

var score = [0, 0]
var maxScore = 1000
let fields  = 10
var player  = 1
var cube    = 0
var maxCube = 100
var count = 0
while score[player] < maxScore {
    player = player == 0 ? 1 : 0
    for _ in 0..<3 {
        cube += 1
        count += 1
        if cube > maxCube {
            cube = 1
        }
        pos[player] += cube
    }
    if pos[player] > fields {
        pos[player] = ((pos[player] - 1) % fields) + 1
    }
    
    score[player] += pos[player]
}

print("Day_21_1:\(score[(player+1)%2])*\(count) = \(score[(player+1)%2]*count)")


pos = [4, 8]
maxScore = 21
let f : Int = 10
var cu : [Int] = []
for i in 1...3 {
    for j in 1...3 {
        for z in 1...3 {
            cu.append(Int(i + j + z))
        }
    }
}
let sc = Array(repeating: [0, 0], count: 24)
let sx = Array(repeating: sc, count: 24)
let pc = Array(repeating: sx, count: 11)
let px = Array(repeating: pc, count: 11)
var cache : [[[[[[Int]]]]]] = Array(repeating: px, count: 2)
//            [[[[[[Int]]]]]] to expected argument type
//             [[[[ [Int] ]]]]
func rec(_ p: [Int], _ s: [Int], _ pl: Int) -> [Int] {
    var res = cache[pl][p[0]][p[1]][s[0]][s[1]]
    if res[0] != 0 || res[1] != 0 {
        return res
    }
    for c in cu {
        var p = p
        var s = s
        p[pl] += c
        if p[pl] > fields {
            p[pl] = ((p[pl] - 1) % f) + 1
        }
        s[pl] += p[pl]
        if s[pl] >= maxScore {
            res[pl] += 1
        } else {
            let r = rec(p, s, pl == 0 ? 1 : 0)
            res[0] += r[0]
            res[1] += r[1]
        }
    }
    cache[pl][p[0]][p[1]][s[0]][s[1]] = res
    return res
}

let res = rec([1, 5], [0, 0], 0)
print("Day_21_1:\(max(res[0],res[1]))")

