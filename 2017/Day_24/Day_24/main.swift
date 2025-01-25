//
//  main.swift
//  Day_24
//
//  Created by Pavlo Liashenko on 04.01.2023.
//

import Foundation

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL).trimmingCharacters(in: .newlines)
var components = inputFileData.components(separatedBy: .newlines).map{$0.components(separatedBy: "/").map{Int($0)!}}
var max = 0
func find(_ tail: Int, _ components: [[Int]], _ sum: Int) {
    var full = true
    for i in 0..<components.count {
        let c = components[i]
        for j in 0..<2 {
            if c[j] == tail {
                var newComponents = components
                let newSum = sum + c[0] + c[1]
                newComponents.remove(at: i)
                find(c[(j+1)%2], newComponents, newSum)
                full = false
            }
        }
    }
    if full {
        if sum > max {
            max = sum
            print("\(max)")
        }
    }
}

find(0, components, 0)
print("Day_24_1: \(max)")//1511

var maxComp = components.count
max = 0
var minComp = maxComp
func find2(_ tail: Int, _ components: [[Int]], _ sum: Int) {
    var full = true
    for i in 0..<components.count {
        let c = components[i]
        for j in 0..<2 {
            if c[j] == tail {
                var newComponents = components
                let newSum = sum + c[0] + c[1]
                newComponents.remove(at: i)
                find2(c[(j+1)%2], newComponents, newSum)
                full = false
            }
        }
    }
    if full {
        if minComp > components.count {
            max = sum
            minComp = components.count
            print("\(maxComp - minComp)/\(max)")
        } else if minComp == components.count {
            if sum > max {
                max = sum
                print("\(maxComp - minComp)/\(max)")
            }
        }
    }
}
find2(0, components, 0)
print("Day_24_2: \(max)")//1511
