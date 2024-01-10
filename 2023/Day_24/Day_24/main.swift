//
//  main.swift
//  Day_24
//
//  Created by Pavlo Liashenko on 24.12.2023.
//

import Foundation
import AdventOfCodeStarterPack

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL).trimmingCharacters(in: .whitespacesAndNewlines)
var hailstones = inputFileData.components(separatedBy:.newlines).map{Hailstone($0)}

struct Hailstone {
    var position, velocity: Position3D
    var a, b: Double
}

extension Hailstone {
    init(position: Position3D, velocity: Position3D) {
        self.position = position
        self.velocity = velocity
        a = Double(velocity.y) / Double(velocity.x)
        b = Double(position.y) - a*Double(position.x)
    }
    
    init(_ position: Position3D, _ velocity: Position3D) {
        self.init(position: position, velocity: velocity)
    }
    
    init(_ position: (Int, Int, Int), _ velocity: (Int, Int, Int)) {
        self.init(Position3D(position), Position3D(velocity))
    }
}

extension Hailstone {
    init(_ str: String) {
        let comps = str.components(separatedBy: " @ ")
        self.init(Position3D(comps[0])!, Position3D(comps[1])!)
    }
}

hailstones.sort{ $0.position.x + $0.position.y + $0.position.z < $1.position.x + $1.position.y + $0.position.z}

let range = 200000000000000.0..<400000000000000.0
var count = 0
for i in 0..<hailstones.count-1 {
    let h1 = hailstones[i]
    for j in i+1..<hailstones.count {
        let h2 = hailstones[j]
        let x = (h2.b - h1.b)/(h1.a - h2.a)
        let y = h1.a * x + h1.b
        let t1 = (x - Double(h1.position.x))/Double(h1.velocity.x)
        let t2 = (x - Double(h2.position.x))/Double(h2.velocity.x)
        if range.contains(x) && range.contains(y) && t1 > 0 && t2 > 0 {
            count += 1
        }
    }
}
print("Day_24_1: \(count)")//17867

func validate(_ rock: Hailstone) -> Bool {
    for hailstone in hailstones {
        for index in 0..<3 {
            guard hailstone.velocity[index] != rock.velocity[index] else {
                if hailstone.position[index] != rock.position[index] {
                    return false
                } else {
                    continue
                }
            }
            let a = (hailstone.position[index] - rock.position[index])
            let b = (rock.velocity[index] - hailstone.velocity[index])
            guard a%b == 0 else {
                return false
            }
            let t2 = a/b
            guard t2 > 0 else {
                return false
            }
        }
    }
    return true
}

var matrix: [[Int]] = []
var results: [Int] = []
for index in 0..<4 {
    let h1 = hailstones[index]
    let h2 = hailstones[index+1]
    matrix.append([
        h2.velocity.y - h1.velocity.y,
        h1.velocity.x - h2.velocity.x,
        h1.position.y - h2.position.y,
        h2.position.x - h1.position.x
    ])
    let result = ( h1.position.y * h1.velocity.x
                   - h1.position.x * h1.velocity.y
                   - h2.position.y * h2.velocity.x
                   + h2.position.x * h2.velocity.y )
    results.append(result)
}

let xy = gaussianElimination(matrix, results)

matrix = []
results = []
for index in 0..<2 {
    let h1 = hailstones[index]
    let h2 = hailstones[index+1]
    matrix.append([
        h1.velocity.x - h2.velocity.x,
        h2.position.x - h1.position.x
    ])
    let result = ( h1.position.z * h1.velocity.x
                   - h1.position.x * h1.velocity.z
                   - h2.position.z * h2.velocity.x
                   + h2.position.x * h2.velocity.z
                   - (h2.velocity.z - h1.velocity.z) * xy[0]
                   - (h1.position.z - h2.position.z) * xy[2])
    results.append(result)
}
let z = gaussianElimination(matrix, results)
var rock = Hailstone((xy[0], xy[1], z[0]), (xy[2], xy[3], z[1]))
print("Day_24_2: \(xy[0] + xy[1] + z[0])")//557743507346379
print("Validate - \(validate(rock) ? "done!" : "fail!!!")")
