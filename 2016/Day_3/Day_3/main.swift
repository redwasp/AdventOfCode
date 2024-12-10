//
//  main.swift
//  Day_3
//
//  Created by Pavlo Liashenko on 27.07.2022.
//

import Foundation

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL)
var triangles = inputFileData
    .trimmingCharacters(in: .whitespacesAndNewlines)
    .components(separatedBy:.newlines)
    .map{
        $0.split(separator:" ", omittingEmptySubsequences:true)
        .map{
            Int($0)!
        }
    }

func validCount(_ triangles : [[Int]]) -> Int {
    var count = 0
    for triangle in triangles {
        if triangle[0] < triangle[1] + triangle[2],
           triangle[1] < triangle[0] + triangle[2],
           triangle[2] < triangle[0] + triangle[1] {
            count += 1
        }
    }
    return count
}

print("Day3_1: \(validCount(triangles))")


var n : [[Int]] = []
for i in 0..<triangles.count/3 {
    for j in 0..<3 {
        n.append([triangles[i*3][j],triangles[i*3+1][j],triangles[i*3+2][j]])
    }
}
triangles = n
print("Day3_2: \(validCount(triangles))")
