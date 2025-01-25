//
//  main.swift
//  Day_23
//
//  Created by Pavlo Liashenko on 05.10.2022.
//

import Foundation

var a = 0, b = 0, c = 0, d = 0, e = 0, f = 0, g = 0, h = 0
var count = 0

b = 67
c = b
if a != 0 {
    b *= 100
    count += 1
    b -= -100000
    c  = b
    c -= -17000
    f = 1
}
repeat {
    f = 1
    d = 2
    repeat {
        e = 2
        repeat {
            g = d
            g *= e
            count += 1
            g -= b
            if g == 0 {
                f  = 0
            }
            e -= -1
            g  = e
            g -= b
        //print("1: \(g)")
        } while g != 0
        d -= -1
        g  = d
        g -= b
    } while g != 0
    
    if f == 0 {
        h -= -1
    }
    g  = b
    g -= c
    if g == 0 {break}
    b -= -17
} while true

print("Day_23_1: \(count)")
count = 0

var x = 106700
count = 0
for _ in 0...1000 {
    var n = 2
    var a = x
    var max = Int(sqrt(Double(a)))
    var isPrime = true
    while a != 1 && n <= max {
        if a % n == 0 {
            isPrime = false
            break
        }
        n += 1
    }
    if !isPrime {
        count += 1
    }
    x += 17
}
print("Day_23_2: \(count)")




