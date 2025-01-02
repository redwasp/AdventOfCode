//
//  main.swift
//  Day_13
//
//  Created by Pavlo Liashenko on 13.12.2024.
//

import Foundation

let inputFileURL  = URL(fileURLWithPath: "input1.txt")
let inputFileData = try! String(contentsOf: inputFileURL, encoding: .utf8).trimmingCharacters(in: .whitespacesAndNewlines)
let machines = inputFileData
    .split(separator:"\n\n")
    .map {
        $0
        .split(separator:"\n")
        .map {
            $0
            .split(separator:": ")[1]
            .split(separator:", ")
            .map{Int(String($0[$0.index($0.startIndex, offsetBy: 2)...]))!}
        }
    }

print("Day_13_1: \(totalCost(machines))")//31897

var newMachines = machines.map {m in
    var m = m
    m[2][0] += 10000000000000;
    m[2][1] += 10000000000000;
    return m
}

print("Day_13_1: \(totalCost(newMachines))")//87596249540359

func totalCost(_ machines: [[[Int]]]) -> Int {
    var totalCost = 0
    for m in machines {
        let a = (m[2][0]*m[1][1]-m[1][0]*m[2][1])/(m[0][0]*m[1][1] - m[1][0]*m[0][1])
        let b = (m[2][0]-a*m[0][0])/m[1][0]
        if a*m[0][0] + b*m[1][0] == m[2][0],
           a*m[0][1] + b*m[1][1] == m[2][1] {
            totalCost += a*3 + b
        }
    }
    return totalCost
}
