//
//  main.swift
//  Day_3
//
//  Created by Pavlo Liashenko on 03.12.2021.
//

import Foundation

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL)
var dataLines = inputFileData.split(separator:"\n" , omittingEmptySubsequences: true)

let matrix = dataLines.map{$0.map{$0 == "1"}}
let count = matrix.count
let size  = matrix[0].count

var gamma   = 0
var epsilon = 0
print("\(count)")
for j in 0..<size {
    var zero = 0
    var one  = 0
    for i in 0..<count {
        if matrix[i][j] {
            zero += 1
        } else {
            one += 1
        }
    }
    gamma <<= 1
    gamma += one > zero ? 1 : 0
    epsilon <<= 1
    epsilon += one < zero ? 1 : 0
}
print("Day_3_1: \(gamma*epsilon)")

var og_rating = matrix
var ogr = 0
for j in 0..<size {
    var zero = 0
    var one  = 0
    for i in 0..<og_rating.count {
        if og_rating[i][j] {
            one += 1
        } else {
            zero += 1
        }
    }
    let most = one >= zero
    og_rating = og_rating.filter { $0[j] == most}
    if (og_rating.count == 1) {
        for item in og_rating.first! {
            ogr <<= 1
            ogr += item ? 1 : 0
        }
        break
    }
}

var cs_rating = matrix
var csr = 0
for j in 0..<size {
    var zero = 0
    var one  = 0
    for i in 0..<cs_rating.count {
        if cs_rating[i][j] {
            one += 1
        } else {
            zero += 1
        }
    }
    let least = zero > one
    cs_rating = cs_rating.filter { $0[j] == least}
    if (cs_rating.count == 1) {
        for item in cs_rating.first! {
            csr <<= 1
            csr += item ? 1 : 0
        }
        break
    }
}
print("Day_3_2: \(ogr*csr)")
