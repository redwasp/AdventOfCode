//
//  main.swift
//  Day_20
//
//  Created by Pavlo Liashenko on 20.12.2021.
//

import Foundation

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL).trimmingCharacters(in: .whitespacesAndNewlines)
let blocks = inputFileData.components(separatedBy: "\n\n")

//image enhancement algorithm
let iea : [Bool] = blocks[0].map {
    switch $0 {
    case "#":
        return true
    default:
        return false
    }
}

var image : [[Bool]] = blocks[1].components(separatedBy: .newlines).map {
    $0.map{
        switch $0 {
        case "#":
            return true
        default:
            return false
        }
    }
}

var height = image.count
var width  = image[0].count

var offset = 4+50
for _ in 0..<offset {
    image.insert(Array(repeating: false, count: width), at: 0)
    image.append(Array(repeating: false, count: width))
}

image = image.map {
    var line = $0

    for _ in 0..<offset {
        line.insert(false, at: 0)
        line.append(false)
    }

    return line
}
height = image.count
width  = image[0].count
var newImage = image;
pr(image)
for step in 0..<50 {
    print("\n\(step)")
//    var minX = Int.max
//    var minY = Int.max
//    var maxX = 0
//    var maxY = 0
//    for y in 0..<height {
//        for x in 0..<width {
//            if image[y][x] {
//                if x < minX {
//                    minX = x
//                }
//                if x > maxX {
//                    maxX = x
//                }
//                if y < minY {
//                    minY = y
//                }
//                if y > maxY {
//                    maxY = y
//                }
//            }
//        }
//    }
//     minX -= 2
//     minY -= 2
//     maxX += 2
//     maxY += 2
    for y in 2..<height-2 {
        for x in 2..<width-2 {
            var bits : [Bool] = []
            var mat : [[Bool]] = []
            for i in -1...1 {
                mat.append([])
                for j in -1...1 {
                    bits.append(image[y+i][x+j])
                    mat[i+1].append(image[y+i][x+j])
                }
            }
            var number = 0
            for bit in bits {
                number <<= 1
                number += bit ? 1 : 0
            }
//            pr(mat)
//            pr([bits])
//            print("X:\(x) Y:\(y) \(number) \(String(number, radix: 2)) \(iea[number] ? "#" : ".") \n")
            newImage[y][x] = iea[number]
        }
    }
    pr(newImage)

    let br = step % 2 == 0 ? iea.first! : iea.last!
        
        for y in 0..<4 {
            for x in 0..<width {
                newImage[y][x] = br
                newImage[height-y-1][x] = br
            }
        }
        for x in 0..<4 {
            for y in 0..<height {
                    newImage[y][x] = br
                    newImage[y][width-x-1] = br
            }
        }
    
    
    image = newImage
    print("--")
    pr(image)
}
pr(image)

//5053 low
//5299 bad
//5086 #2 low
let count = image.reduce(0) { $0 + $1.reduce(0, { $0 + ($1 ? 1 : 0)})}
print("Day_20_1: \(count)")

func pr(_ image: [[Bool]]) {
    for y in 0..<image.count {
        var str = ""
        for x in 0..<image[y].count {
            str += image[y][x] ? "#" : "_"
        }
        print(str)
    }
}
