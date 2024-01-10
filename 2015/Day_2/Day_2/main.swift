//
//  main.swift
//  Day_2
//
//  Created by Pavlo Liashenko on 16.05.2022.
//

import Foundation

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL)
let lines = inputFileData.split(separator: "\n", omittingEmptySubsequences: true)
let boxes = lines.map{$0.components(separatedBy:"x").map{Int($0)!}}
var sumPaperArea = 0
var sumRibbonLength = 0

for box in boxes {
    let area = calcPaperArea(for: box)
    sumPaperArea += area
    let length = calcRibbonLength(for: box)
    sumRibbonLength += length
}


print("Day_2_1: \(sumPaperArea)")
print("Day_2_2: \(sumRibbonLength)")

func calcPaperArea(for box: [Int]) -> Int {
    var aera = 0
    var prevEdge = box.last!
    var min = Int.max
    for edge in box {
        let faceAera = edge*prevEdge
        if min > faceAera {
            min = faceAera
        }
        aera += 2*faceAera
        prevEdge = edge
    }
    aera += min
    return aera
}

func calcRibbonLength(for box: [Int]) -> Int {
    var length = 0
    var mult = 1
    let edges = box.sorted()
    for (index, edge) in edges.enumerated() {
        mult *= edge
        if index != 2 {
            length += 2*edge
        }
    }
    length += mult
    return length
}
