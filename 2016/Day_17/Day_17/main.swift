//
//  main.swift
//  Day_17
//
//  Created by Pavlo Liashenko on 21.08.2022.
//

import Foundation
import CryptoKit

let salt = "qtetzkpl"
let data = salt.data(using: .utf8)!

struct State : CustomStringConvertible {
    let path : String
    let x    : Int
    let y    : Int
    
    var description: String {
        "\(path) X:\(x) Y:\(y)"
    }
}
var variants : [State] = [State(path: "", x: 0, y: 0)]
var exit = false
var dir = ["U", "D", "L", "R"]
var dx  = [ 0,   0,   -1,  1 ]
var dy  = [-1,   1,    0,  0 ]

var min = Int.max
var max = 0
while variants.count != 0 {
    var nvariants : [State] = []
    for state in variants {
        if state.x == 3 && state.y == 3 {
            if state.path.count < min {
                min = state.path.count
            }
            if state.path.count > max {
                max = state.path.count
            }
            continue
        }
        let variant = (salt + state.path).data(using: .utf8)!
        let hash    = Insecure.MD5.hash(data: variant)
        let str = hash.map { String(format: "%02hhx", $0) }.joined().prefix(4).map{$0}
        for (index, char) in str.enumerated() {
            if Int(String(char), radix: 16)! > 10 {
                let npath = state.path + String(dir[index])
                let nx = state.x + dx[index]
                let ny = state.y + dy[index]
                guard nx >= 0, ny >= 0, nx < 4, ny < 4 else {continue}
                nvariants.append(State(path: npath, x: nx, y: ny))
            }
        }
    }
    variants = nvariants
}

print("Day17_1: \(min)")
print("Day17_2: \(max)")
