//
//  main.swift
//  Day_21
//
//  Created by Pavlo Liashenko on 04.10.2022.
//

import Foundation

func flip(_ matrix : [[Bool]]) -> [[Bool]] {
    return matrix.map{return $0.reversed()}
}

func rotate(_ matrix : [[Bool]]) -> [[Bool]] {
    var newMatrix = Array(repeating: Array(repeating: false, count: matrix.count), count: matrix.count)
    for i in 0..<matrix.count {
        for j in 0..<matrix.count {
            newMatrix[i][j] = matrix[j][matrix.count-i-1]
        }
    }
    return newMatrix
}

func isEqual(_ matrix : [[Bool]], _ template : [[Bool]]) -> Bool {
    for i in 0..<matrix.count {
        for j in 0..<matrix.count {
            if matrix[i][j] != template[i][j] {
                return false
            }
        }
    }
    return true
}

func isValid(_ matrix : [[Bool]], _ template : [[Bool]]) -> Bool {
    var item = matrix
    for _ in 0...3 {
        if isEqual(item, template) {
            return true
        }
        let flipItem = flip(item)
        if isEqual(flipItem, template) {
            return true
        }
        item = rotate(item)
    }
    return false
}
func prMT(_ matrix : [[Bool]]) {
    var string = ""
    for line in matrix {
        for item in line {
            if item {
                string += "#"
            } else {
                string += "."
            }
        }
        string += "\n"
    }
    print(string)
}

var image = """
.#.
..#
###
"""

let inputData = try! Data(contentsOf: URL(fileURLWithPath:"input.txt"))
let inputString = String(data:inputData , encoding: .utf8)!
let lines = inputString.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines)
var patterns2 : [[[[Bool]]]] = []
var patterns3 : [[[[Bool]]]] = []

for line in lines {
    let components = line.components(separatedBy:" => ")
    let pattern = components.map{ return $0.split(separator: "/").map{ return String($0).map{ return $0 == "#" }}}
    var array : [[[[Bool]]]] = []
    var item = pattern[0]
    for _ in 0...3 {
        var skip = false
        for pr in array {
            if isEqual(pr[0], item) {
                skip = true
                break;
            }
        }
        if (skip) {
            item = rotate(item)
            continue
        }
        array.append([item, pattern[1]])
        let flipItem = flip(item)
        if !isEqual(flipItem, item) {
            array.append([flipItem, pattern[1]])
        }
        item = rotate(item)
    }
    if pattern[0].count == 2 {
        patterns2.append(contentsOf:array)
    } else {
        patterns3.append(contentsOf:array)
    }
}
let matrix = image.split(separator: "\n").map{ return String($0).map{ return $0 == "#" }}

func process(_ steps: Int) -> Int {
    var matrix = matrix
    for _ in 0..<steps {
        let is2 = (matrix.count%2) == 0
        let templates = is2 ? patterns2 : patterns3
        let sampleSize = is2 ? 2 : 3
        let sqCount = matrix.count / sampleSize
        let newSize = sqCount*(sampleSize+1)
        var newMatrix = Array(repeating: Array(repeating: false, count:newSize), count:newSize)
        for i in 0..<sqCount {
            for j in 0..<sqCount {
                let sample = Array(matrix[i*sampleSize..<(i+1)*sampleSize].map{return Array($0[j*sampleSize..<(j+1)*sampleSize])})
                for template in templates {
                    if isEqual(sample, template[0]) {
                        for ii in 0..<sampleSize+1 {
                            for jj in 0..<sampleSize+1 {
                                let ni = i*(sampleSize+1) + ii
                                let nj = j*(sampleSize+1) + jj
                                newMatrix[ni][nj] = template[1][ii][jj]
                            }
                        }
                        break;
                    }
                }
            }
        }
        matrix = newMatrix
    }
    return matrix.reduce(into: 0) { $0 += $1.reduce(into: 0, { $0 += $1 ? 1 : 0})}
}

print("Day_21_1: \(process(5))")
print("Day_21_2: \(process(18))")//3081737

