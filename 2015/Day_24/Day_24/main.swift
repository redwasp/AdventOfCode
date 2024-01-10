//
//  main.swift
//  Day_24
//
//  Created by Pavlo Liashenko on 30.05.2022.
//

import Foundation

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL)
let lines = inputFileData.split(separator: "\n", omittingEmptySubsequences: true)
let weights = Array(lines.map{Int($0)!}.reversed())
let sum = weights.reduce(0, +)

func findQE(_ count: Int) -> Int { //QE - "quantum entanglement"
    let target = sum/count
    var maxSize = Int.max
    var minQE = Int.max
    func process(_ sum: Int, _ mul: Int, _ offset: Int, _ size: Int) {
        guard size < maxSize else {return}
        for index in offset..<weights.count {
            let item = weights[index]
            let newSum = sum + item
            let newMul = mul * item // overflow
            let newSize = size + 1
            guard newSum <= target else {continue}
            if newSum < target {
                process(newSum, newMul, index+1, newSize)
            } else if newSum == target {
                if newSize < maxSize {
                    maxSize = newSize
                    minQE = newMul
                } else if newMul < minQE {
                    minQE = newMul
                }
            }
        }
    }
    process(0, 1, 0, 0)
    return minQE
}

print("Day_24_1: \(findQE(3))")//11846773891
print("Day_24_2: \(findQE(4))")//80393059
