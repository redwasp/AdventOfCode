//
//  main.swift
//  Day_25
//
//  Created by Pavlo Liashenko on 27.05.2022.
//

import Foundation

var code = 20151125
let m = 252533 //Prime
let d = 33554393
let row = 2978
let column = 3083

var index = 0
index += row*(row-1)/2
index += (2*row+column)*(column-1)/2

//Fast modular exponentiation r = m^n mod d
var n = index
var r = 1
var bm = m // m^2, m^4, m^8 ....
while n != 0 {
    if n % 2 == 1 {
        r = r*bm % d
    }
    n /= 2
    bm = bm*bm % d
}

code = r*code % d
print("Day_25: \(code)")//2650453
