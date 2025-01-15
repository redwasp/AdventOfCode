//
//  main.swift
//  Day_22
//
//  Created by Pavlo Liashenko on 24.12.2024.
//

import Foundation

let inputFileURL  = URL(fileURLWithPath: "input1.txt")
let inputFileData = try! String(contentsOf: inputFileURL, encoding: .utf8).trimmingCharacters(in: .whitespacesAndNewlines)
var numbers = inputFileData.components(separatedBy: .newlines).map{Int($0)!}

func next(_ a: Int) -> Int {
    let b = ((a<<6) ^ a) % 16777216
    let c = ((b>>5) ^ b) % 16777216
    let d = ((c<<11) ^ c) % 16777216
    return d
}

var sum = 0
for var n in numbers {
    for _ in 0..<2000 {
        n = next(n)
    }
    sum += n
}
print("Day_22_1:",sum)//18941802053


var price = 0
var prices: [[Int]:Int] = [:]

var sample: [Int] = []
var used: Set<[Int]> = []
var prev = 0
for var n in numbers {
    prev = n % 10
    sample = []
    used  = []
    for _ in 0..<2000 {
        n = next(n)
        price = n % 10
        sample.append(price - prev)
        prev = price

        if sample.count == 5 {
            sample.removeFirst()
            if used.contains(sample) {
                continue
            }
            used.insert(sample)
            prices[sample, default: 0] += price
        }
    }
}
let result2 = prices.max(by: {$0.value < $1.value})!.value
print("Day_22_2:", result2)//2218
