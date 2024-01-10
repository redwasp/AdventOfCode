//
//  main.swift
//  Day_18
//
//  Created by Pavlo Liashenko on 18.12.2023.
//

import Foundation
import AdventOfCodeStarterPack

struct Edge {
    let length: Int
    let direction: Position
    init(_ length: Int, _ direction: Position) {
        self.length = length
        self.direction = direction
    }
    init(_ str: String, part: Int) {
        let comp = str.components(separatedBy:.whitespaces)
        if (part == 1) {
            switch comp[0] {
            case "U":
                direction = .up
            case "D":
                direction = .down
            case "L":
                direction = .left
            case "R":
                direction = .right
            default:
                direction = .zero
            }
            length = Int(comp[1])!
        } else {
            var color = comp[2].trimmingCharacters(in:CharacterSet(charactersIn:"(#)"))
            let dir = color.removeLast()
            switch dir {
            case "0":
                direction = .right
            case "1":
                direction = .down
            case "2":
                direction = .left
            case "3":
                direction = .up
            default:
                direction = .zero
            }
            length = Int(color, radix: 16)!
        }
    }
}

let inputFileURL  = Bundle.main.url(forResource: "input", withExtension: "txt")!
let inputFileData = try! String(contentsOf: inputFileURL).trimmingCharacters(in: .whitespacesAndNewlines)

func fill(_ edges:[Edge], _ field: [[Bool]], _ start: Position) -> [[Bool]] {
    var field = field
    var start = start
    let contur = field
    var prevDirection = Position.zero;
    for edge in edges {
        var offset = 0
        if prevDirection == edge.direction.rotatedRight() {
            offset = 1
            start -= edge.direction
        }
        for _ in 0..<edge.length + offset  {
            var direction = edge.direction
            start += edge.direction
            for _ in 0..<2 {
                direction = direction.rotatedRight()
                var pos = start + direction
                while contur[safe: pos] == false {
                    field[pos] = true
                    pos += direction
                }
            }
        }
        prevDirection = edge.direction
    }
    return field;
}

func optimize(_ edges: [Edge]) -> (edges: [Edge], field: [[Bool]] , sizes: [[Int]], startPoint: Position) {
    var setX: Set<Int> = []
    var setY: Set<Int> = []
    var start = Position(1, 1)
    for edge in edges {
        for offset in [-1, 0, 1, edge.length, edge.length+1] {
            let position = start + offset*edge.direction
            setX.insert(position.x)
            setY.insert(position.y)
        }
        start = start + edge.direction*edge.length
    }
    var Xs = setX.sorted()
    var Ys = setY.sorted()
    let offset = Position(Xs.first!, Ys.first!)
    let startPosition = Position(Xs.firstIndex(of: 1)!, Ys.firstIndex(of: 1)!)
    Xs = Xs.map{$0 - offset.x}
    Ys = Ys.map{$0 - offset.y}
    var field = Array(repeating:Array(repeating: false, count: Xs.count), count: Ys.count)
    start = Position(1, 1) - offset
    var from = startPosition
    var to   = startPosition
    var newEdges : [Edge] = []
    for edge in edges {
        start += edge.direction*edge.length
        to = Position(Xs.firstIndex(of:start.x)!, Ys.firstIndex(of:start.y)!)
        var length = 0
        while from != to {
            length += 1
            from += edge.direction
            field[from] = true
        }
        newEdges.append(Edge(length, edge.direction))
    }
    
    var sizes = Array(repeating:Array(repeating: 0, count: Xs.count), count: Ys.count)

    for y in 0..<Ys.count-1 {
        for x in 0..<Xs.count-1 {
            sizes[y][x] = (Xs[x+1] - Xs[x])*(Ys[y+1] - Ys[y])
        }
    }
    
    return (newEdges, field, sizes, startPosition)
}

func lavaCount(_ edges: [Edge]) -> Int {
    let (newEdges, field, sizes, startPoint) = optimize(edges)
    var sum = 0
    let filled = fill(newEdges, field, startPoint)
    for y in 0..<filled.count {
        for x in 0..<filled[y].count {
            if (filled[y][x]) {
                sum += sizes[y][x]
            }
        }
    }
    return sum;
}

let edges1 = inputFileData.components(separatedBy:.newlines).map{Edge($0, part:1)}
print("Day_18_1: \(lavaCount(edges1))")//49061

let edges2 = inputFileData.components(separatedBy:.newlines).map{Edge($0, part:2)}
print("Day_18_2: \(lavaCount(edges2))")//92556825427032
