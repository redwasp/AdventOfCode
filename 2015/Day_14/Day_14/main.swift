//
//  main.swift
//  Day_14
//
//  Created by Pavlo Liashenko on 28.06.2022.
//

import Foundation
class Reindeer {
    enum State {
        case run
        case rest
    }
    let name     : String
    var speed    : Int
    var power    : Int
    var rest     : Int
    var time     : Int = 0
    var state    : State = .run
    var position : Int = 0
    var points   : Int = 0

    init(_ line: String) {
        let parts = line.split(separator:" ")
        name  = String(parts[0])
        speed = Int(parts[3])!
        power = Int(parts[6])!
        rest  = Int(parts[13])!
        time  = power
    }
    
    func next() {
        time -= 1
        switch state {
        case .run:
            position += speed
            if time == 0 {
                state = .rest
                time = rest
            }
        case .rest:
            if time == 0 {
                state = .run
                time = power
            }
        }
    }
}

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL)
let lines = inputFileData.split(separator: "\n", omittingEmptySubsequences: true)
let reindeers = lines.map{Reindeer(String($0))}

let secconds = 2503
for _ in 0..<secconds {
    for reindeer in reindeers {
        reindeer.next()
    }
    let max = reindeers.max { $0.position < $1.position}!
    max.points += 1
}


let first = reindeers.max { $0.position < $1.position}!

print("Day_14_1: \(first.name) \(first.position)");

let win = reindeers.max { $0.points < $1.points}!

print("Day_14_2: \(win.name) \(win.points)");
