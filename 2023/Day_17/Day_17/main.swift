//
//  main.swift
//  Day_17
//
//  Created by Pavlo Liashenko on 17.12.2023.
//

import Foundation
import AdventOfCodeStarterPack

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL).trimmingCharacters(in: .whitespacesAndNewlines)
let field = inputFileData.components(separatedBy:.newlines).map{$0.map{Int(String($0))!}}
let size = field.size
let last = field.size - Position(1,1)

struct Item: Hashable {
    let position: Position
    let direction: Position
    init(_ position: Position, _ direction: Position) {
        self.position = position
        self.direction = direction
    }
}

func  leastHeat(_ stepsRange: ClosedRange<Int>) -> Int {
    var map: [Item: Int] = [:]
    var items: [Item] = [Item(.zero, .zero)]
    var min = 9*(field.size.x + field.size.y - 1)
    let stepsMin = stepsRange.lowerBound
    let stepsMax = stepsRange.upperBound
    while items.count > 0 {
        var newItems: Set<Item> = []
        for item in items {
            let pValue = map[item] ?? 0
            for direction in Directions.clockwise {
                
                guard item.direction.reversed() != direction else {
                    continue
                }
                guard item.direction != direction else {
                    continue
                }
                var nPosition = item.position
                var nValue = pValue
                for step in 1...stepsMax {
                    nPosition += direction
                    
                    guard let fValue = field[safe: nPosition] else {
                        //print("-\(nPosition) 2")
                        break
                    }
                    nValue += fValue
                    if (nValue > min) {
                        break
                    }
                    if nPosition == last && step >= stepsMin {
                        if (nValue < min) {
                            min = nValue
                        }
                        break
                    }
                    let nKey = Item(nPosition, direction)
                    if nValue < (map[nKey] ?? Int.max) && step >= stepsMin {
                        map[nKey] = nValue
                        newItems.insert(nKey)
                    }
                }
            }
        }
        items = newItems.sorted(by: {$0.position.distance(to:last) < $1.position.distance(to:last)})
    }
    return min
}

print("Day_17_1: \(leastHeat(1...3))")//907
print("Day_17_2: \(leastHeat(4...10))")//1057
