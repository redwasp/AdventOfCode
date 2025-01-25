//
//  main.swift
//  Day_13
//
//  Created by Pavlo Liashenko on 20.01.2023.
//

import Foundation
import Position

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL).trimmingCharacters(in: .newlines)

var field = inputFileData.components(separatedBy:.newlines).map{$0.map{$0}}
var cars : [Car] = []
for y in 0..<field.count {
    for x in 0..<field[y].count {
        let location = Position(x, y)
        var direction: Position? = nil
        switch field[location] {
        case ">":
            direction = .right
            field[location] = "-"
        case "<":
            direction = .left
            field[location] = "-"
        case "^":
            direction = .up
            field[location] = "|"
        case "v":
            direction = .down
            field[location] = "|"
        default:
            break
        }
        guard let direction = direction else {continue}
        cars.append(Car(location, direction))
    }
}
struct Car: Hashable {
    var location  : Position
    var direction : Position
    var turn : Int = 0
    init(_ locatiion: Position, _ direction: Position) {
        self.location = locatiion
        self.direction = direction
    }
}
//prf()
var isFirst = true

while cars.count > 1 {
    var craches: Set<Int> = []
    for i in 0..<cars.count {
        guard !craches.contains(i) else {continue}
        cars[i].location += cars[i].direction
        for j in 0..<cars.count  {
            guard i != j else {continue}
            if cars[i].location == cars[j].location {
                craches.insert(i)
                craches.insert(j)
                if isFirst {
                    print("Day_13_1: \(cars[i].location)")
                    isFirst = false
                }
            }
        }
        switch field[cars[i].location] {
        case "+":
            if cars[i].turn == 0 {
                cars[i].direction.rotateLeft()
            } else if cars[i].turn == 2 {
                cars[i].direction.rotateRight()
            }
            cars[i].turn += 1
            cars[i].turn %= 3
        case "/":
            switch cars[i].direction {
            case .up :
                cars[i].direction = .right
            case .down:
                cars[i].direction = .left
            case .left:
                cars[i].direction = .down
            case .right:
                cars[i].direction = .up
            default:
                break
            }
        case "\\":
            switch cars[i].direction {
            case .up :
                cars[i].direction = .left
            case .down:
                cars[i].direction = .right
            case .left:
                cars[i].direction = .up
            case .right:
                cars[i].direction = .down
            default:
                break
            }
        default:
            break
        }
    }
    for index in craches.sorted().reversed() {
        cars.remove(at:index)
    }
    cars.sort{$0.location < $1.location}
}

print("Day_13_2: \(cars.last!.location)")
