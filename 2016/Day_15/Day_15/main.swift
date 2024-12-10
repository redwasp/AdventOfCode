//
//  main.swift
//  Day_15
//
//  Created by Pavlo Liashenko on 18.08.2022.
//

import Foundation

struct Disc : CustomStringConvertible{
    let size     : Int
    var position : Int
    var offset   : Int
    init(_ string: String) {
        let parts = string.dropLast().components(separatedBy: .whitespaces)
        size     = Int(parts[3])!
        position = Int(parts.last!)!
        offset   = Int(parts[1].dropFirst())!
    }
    
    var description: String {
        "#\(offset):\(position)\\\(size)"
    }
}

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL)
var lines = inputFileData.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines)
var discs = lines.map {Disc($0)}
print("\(discs)")

func find(_ discs: [Disc]) -> Int {
    var step = -1
    var exit = false

    while !exit {
        step += 1
        exit = true
        for disc in discs {
            if (disc.position + disc.offset + step) % disc.size != 0 {
                exit = false
            }
        }
    }
    return step
}

print("Day_15_1: \(find(discs))")
discs.append(Disc("Disc #7 has 11 positions; at time=0, it is at position 0."))
print("Day_15_2: \(find(discs))")
