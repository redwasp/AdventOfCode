//
//  main.swift
//  Day_14
//
//  Created by Pavlo Liashenko on 22.01.2023.
//

import Foundation

var input = 503761

var i = 0
var j = 1
var recipes : [Int] = [3, 7, 1, 0]
var steps = input
let n = input
var fr : [Int] = []
while input != 0 {
    fr.insert(input%10, at: 0)
    input /= 10
}

var step = 2
var exit = false
while !exit {
    let n = recipes[i]+recipes[j]
    var sn = 0
    if n < 10 {
        recipes.append(n)
        sn = 1
    } else {
        recipes.append(n/10)
        recipes.append(n%10)
        sn = 2
    }
    if (recipes.count > fr.count) {
        for s in 0..<sn {
            var qc = 0
            for x in 0...fr.count-1 {
                if (fr[fr.count-1-x] == recipes[recipes.count-1-x-s]) {
                    qc += 1
                }
            }
            if qc == fr.count {
                print("Day_14_2: \(recipes.count-fr.count-s)")
                exit = true
            }
        }
    }
    if step == steps {
        var str = ""
        for i in 0...9 {
            str += String(recipes[steps+i])
        }
        print("Day_14_1: \(str)")
    }
    step += 1
    i = (i + recipes[i] + 1) % recipes.count
    j = (j + recipes[j] + 1) % recipes.count
}


