//
//  main.swift
//  Day_15
//
//  Created by Pavlo Liashenko on 14.09.2022.
//

import Foundation

var gA = 699
var gB = 124
let gAF = 16807
let gBF = 48271
let dF = 2147483647
var count = 0
for _ in 0..<40000000 {
    gA = gA*gAF%dF
    gB = gB*gBF%dF
    if gA&0xFFFF == gB&0xFFFF {
        count+=1
    }
}

print("Day_15_1: \(count)")


gA = 699
gB = 124
count = 0
for _ in 0..<5000000 {
    repeat {
        gA = gA*gAF%dF
    } while gA%4 != 0
    repeat {
        gB = gB*gBF%dF
    } while gB%8 != 0
    if gA&0xFFFF == gB&0xFFFF {
        count+=1
    }
}

print("Day_15_2: \(count)")
