//
//  main.swift
//  Day_15
//
//  Created by Pavlo Liashenko on 19.12.2022.
//

import Foundation
import AdventOfCodeStarterPack

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL).trimmingCharacters(in: .whitespacesAndNewlines)
var log = inputFileData
            .components(separatedBy:.newlines)
            .map {
                $0
                .components(separatedBy: ":")
                .map {
                    $0
                    .components(separatedBy: ",")
                    .map {
                        Int($0
                            .components(separatedBy: "=")
                            .last!)!
                    }
                }
                .map {
                    Position($0)!
                }
            }
            .map {
                (sensor: $0[0], beacon: $0[1], size: $0[0].distance(to: $0[1]))
            }

var targetY = 2000000
var targetRow : Set<Int> = []
for line in log {
    let sensor = line.sensor
    let width = line.size - abs(sensor.y - targetY)
    if width >= 0 {
        targetRow.formUnion((sensor.x - width)...(sensor.x + width))
    }
}

for line in log {
    if line.beacon.y == targetY {
        targetRow.remove(line.beacon.x)
    }
}

print("Day_15_1: \(targetRow.count)")//4793062

let field: ClosedRange<Position> = .zero ... Position(4000000, 4000000)

func isValid(_ test: Position) -> Bool {
    guard field.contains(test) else {return false}
    for line in log {
        let sensor = line.sensor
        let distance = sensor.distance(to: test)
        if distance <= line.size {
            return false
        }
    }
    return true
}

func intersection(_ lines: [[Position]]) -> [Position] {
    var p11 = lines[0][0]
    var p12 = lines[0][1]
    var p21 = lines[1][0]
    var p22 = lines[1][1]
    
    var d1 = (p12 - p11).direction
    var d2 = (p22 - p21).direction
    if d1.x != 1 {
        (p11, p12) = (p12, p11)
        d1 = Position(1, -d1.y)
    }
    if d2.x != 1 {
        (p21, p22) = (p22, p21)
        d2 = Position(1, -d1.y)
    }
    if d1.y == d2.y {return []}
    if d1.y == -1 {
        (p11, p12, p21, p22) = (p21, p22, p12, p11)
        (d1, d2) = (d2, d1)
    }
    
    let x01 = p11.x - p11.y
    let x02 = p21.x + p21.y
    let x = (x01 + x02)/2
    let y = x - x01
    let target = Position(x, y)
    let isRect = (x01 + x02) % 2 != 0

    guard Rect(p11, p12).contains(target) else {return []}
    guard Rect(p21, p22).contains(target) else {return []}

    if isRect {
        return [target, target + .one, target + .right, target + .down]
    } else {
        return [target]
    }
}

var rhombus = log.map { line in
    Directions.clockwise.map{$0 * line.size + line.sensor}
}

var intersections : [Position] = []
for rhomb1Index in 0..<rhombus.count-1 {
    let vertices1 = rhombus[rhomb1Index]
    for rhomb2Index in (rhomb1Index+1)..<rhombus.count  {
        let vertices2 = rhombus[rhomb2Index]
        guard vertices1 != vertices2 else {continue}
        for vertex1Index in 0..<4 {
            let vertex11 = vertices1[vertex1Index]
            let vertex12 = vertices1[(vertex1Index + 1)%4]
            for vertex2Index in 0..<4 {
                let vertex21 = vertices2[vertex2Index]
                let vertex22 = vertices2[(vertex2Index + 1)%4]
                let targets = intersection([[vertex11, vertex12], [vertex21, vertex22]].map{$0.sorted()}).filter {
                    field.contains($0)
                }
                intersections.append(contentsOf: targets)
            }
        }
    }
}
intersections = Array(Set(intersections))
intersections.sort(using:.YX)

var previos = intersections.last!
for intersection in intersections {
    if previos.y == intersection.y && intersection.x - previos.x ==  2  {
        var pos = intersection
        pos.x -= 1
        print("\(pos)")
        print("Day_15_2: \(pos.x*4000000 + pos.y)")//10826395253551//12567351400528
    }
    previos = intersection
}
