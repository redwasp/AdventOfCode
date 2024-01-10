//
//  main.swift
//  Day_16
//
//  Created by Pavlo Liashenko on 16.12.2023.
//

import Foundation
import AdventOfCodeStarterPack

enum Tile: Character, Hashable {
    case empty = "."
    case reflectUpward = "/"
    case reflectDownward = "\\"
    case splitVertical = "|"
    case splitHorizontal = "-"
}

struct Beam: Hashable  {
    var position: Position
    var direction: Position
    init(_ position: Position, _ direction: Position) {
        self.position = position
        self.direction = direction
    }
}

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL).trimmingCharacters(in: .whitespacesAndNewlines)
let field = inputFileData.components(separatedBy:.newlines).map{$0.map{Tile(rawValue:$0)!}}


func nextBeams(for beam: Beam) -> [Beam] {
    switch field[beam.position] {
    case .empty: 
        [Beam(beam.position+beam.direction, beam.direction)]
    case .splitVertical:
        if (beam.direction == .up || beam.direction == .down) {
            [Beam(beam.position + beam.direction, beam.direction)]
        } else {
            [Beam(beam.position.up(), .up),
             Beam(beam.position.down(), .down)]
        }
    case .splitHorizontal:
        if (beam.direction == .left || beam.direction == .right) {
            [Beam(beam.position + beam.direction, beam.direction)]
        } else {
            [Beam(beam.position.left(), .left),
             Beam(beam.position.right(), .right)]
        }
    case .reflectUpward:
        switch beam.direction {
            case .right:
                [Beam(beam.position + .up, .up)]
            case .left:
                [Beam(beam.position + .down, .down)]
            case .down:
                [Beam(beam.position + .left, .left)]
            case .up:
                [Beam(beam.position + .right, .right)]
            default: []
        }
    case .reflectDownward:
        switch beam.direction {
            case .right:
                [Beam(beam.position + .down, .down)]
            case .left:
                [Beam(beam.position + .up, .up)]
            case .down:
                [Beam(beam.position + .right, .right)]
            case .up:
                [Beam(beam.position + .left, .left)]
            default: []
        }
    }
}

func energizedTilesCount(_ start: Beam) -> Int {
    var beams: [Beam] = [start]
    var energizedField : [[Set<Position>]] = Array(repeating: Array(repeating:[], count: field.size.x), count: field.size.y)
    while beams.count != 0 {
        var newBeams: Set<Beam> = []
        for beam in beams {
            guard !energizedField[beam.position].contains(beam.direction) else {continue}
            energizedField[beam.position].insert(beam.direction)
            newBeams.formUnion(nextBeams(for: beam))
        }
        beams = newBeams.filter {
            field[safe: $0.position] != nil
        }
    }
    return energizedField.reduce(into: 0) {
        $0 += $1.reduce(into: 0, {
            $0 += $1.count > 0 ? 1 : 0
        })
    }
}

print("Day_16_1: \(energizedTilesCount(Beam(.zero, .right)))")//7788

var max = 0
for y in 0..<field.size.y {
    let count = energizedTilesCount(Beam(Position(0, y), .right))
    if count > max {
        max = count
    }
}
for y in 0..<field.size.y {
    let count = energizedTilesCount(Beam(Position(field.size.x - 1, y), .left))
    if count > max {
        max = count
    }
}
for x in 0..<field.size.x {
    let count = energizedTilesCount(Beam(Position(x, 0), .down))
    if count > max {
        max = count
    }
}
for x in 0..<field.size.x {
    let count = energizedTilesCount(Beam(Position(x, field.size.y - 1), .up))
    if count > max {
        max = count
    }
}

print("Day_16_2: \(max)")//7987
