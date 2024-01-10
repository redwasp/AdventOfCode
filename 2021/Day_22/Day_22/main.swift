//
//  main.swift
//  Day_22
//
//  Created by Pavlo Liashenko on 22.12.2021.
//

import Foundation

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL).trimmingCharacters(in: .whitespacesAndNewlines)
let lines : [(value: Bool, range: [ClosedRange<Int>])] = inputFileData.components(separatedBy: .newlines).map {
    let comp = $0.components(separatedBy: " ")
    let value = comp[0] == "on" ? true : false
    let range = comp[1].components(separatedBy:",").map{$0.components(separatedBy: "=")[1].components(separatedBy:"..").map{Int($0)!}}.map {
        $0[0]...$0[1]
    }
    
    return (value, range)
}
let fieldRange = -50...50
let fieldSize = fieldRange.count
var field : [[[Bool]]] = Array(repeating: Array(repeating: Array(repeating: false, count: fieldSize), count: fieldSize), count: fieldSize)

func limit(_ range: ClosedRange<Int>, to limit: ClosedRange<Int>) -> ClosedRange<Int>? {
    guard range.overlaps(limit) else {return nil}
    return range.clamped(to: limit)
}

var step = 0
for item in lines {
    guard let xRange = limit(item.range[0], to: fieldRange),
          let yRange = limit(item.range[1], to: fieldRange),
          let zRange = limit(item.range[2], to: fieldRange)
    else {continue}

    for x in xRange {
        for y in yRange {
            for z in zRange {
                field[50+z][50+y][50+x] = item.value
            }
        }
    }
    let count = field.reduce(0){ $0 + $1.reduce(0, { $0 + $1.reduce(0){$0 + ($1 ? 1 : 0)}})}
}

let count = field.reduce(0){ $0 + $1.reduce(0, { $0 + $1.reduce(0){$0 + ($1 ? 1 : 0)}})}
print("Day22_1: \(count)")

func intersection(_ a: [ClosedRange<Int>], _ b: [ClosedRange<Int>]) -> [ClosedRange<Int>]? {
    var range : [ClosedRange<Int>] = []
    for i in 0..<a.count {
        if let x = limit(a[i] , to: b[i]) {
            range.append(x)
        } else {
            return nil
        }
    }
    return range
}

func intersect(_ a: [ClosedRange<Int>], _ b: [ClosedRange<Int>]) -> Bool {
    for i in 0..<a.count {
        if !a[i].overlaps(b[i]) {
            return false
        }
    }
    return true
}

func contain(_ a: [ClosedRange<Int>], _ b: [ClosedRange<Int>]) -> Bool {
    for i in 0..<a.count {
        guard a[i].lowerBound <= b[i].lowerBound,
              a[i].upperBound >= b[i].upperBound
        else {return false}
    }
    return true
}

func split(_ a: ClosedRange<Int>, _ b: ClosedRange<Int>) -> [ClosedRange<Int>] {
    var parts : [ClosedRange<Int>] = []
    if a.lowerBound > b.lowerBound {
       return split(b, a)
   } else if a.lowerBound < b.lowerBound {
        parts.append(a.lowerBound...(b.lowerBound-1))
        if b.upperBound < a.upperBound {
            parts.append(b)
            parts.append((b.upperBound+1)...a.upperBound)
        } else {
            parts.append(b.lowerBound...a.upperBound)
            if a.upperBound < b.upperBound {
                parts.append((a.upperBound+1)...b.upperBound)
            }
        }
    } else {
        if b.upperBound < a.upperBound {
            parts.append(b.lowerBound...b.upperBound)
            parts.append((b.upperBound+1)...a.upperBound)
        } else if b.upperBound > a.upperBound {
            parts.append(a.lowerBound...a.upperBound)
            parts.append((a.upperBound+1)...b.upperBound)
        } else {
            return [a]
        }
    }
    return parts
}

func substract(_ a: [ClosedRange<Int>], _ b: [ClosedRange<Int>]) -> [[ClosedRange<Int>]] {
    var subranges : [[ClosedRange<Int>]] = []
    for i in 0..<a.count {
        subranges.append(split(a[i], b[i]))
    }
    var result : [[ClosedRange<Int>]] = []
    for x in subranges[0] {
        for y in subranges[1] {
            for z in subranges[2] {
                let cub = [x,y,z]
                if contain(a, cub) && !contain(b, cub) {
                    result.append(cub)
                }
            }
        }
    }
    return result
}

var items = lines
var ranges : [[ClosedRange<Int>]] = [items.removeFirst().range]

for item in items {
    let union = item.value
    var parts = [item.range]
    var rPos = 0
    while rPos < ranges.count  {
        let range = ranges[rPos]
        var pos   = 0
        if union {
            while pos < parts.count  {
                if intersect(range, parts[pos]) {
                    let splits = substract(parts[pos], range)
                    parts.remove(at: pos)
                    parts.insert(contentsOf: splits, at: pos)
                    pos += splits.count
                } else {
                    pos += 1
                }
            }
            rPos += 1
        } else {
            if intersect(range, parts[pos]) {
                let splits = substract(range, parts[pos])
                ranges.remove(at: rPos)
                ranges.insert(contentsOf: splits, at: rPos)
                rPos += splits.count
            } else {
                rPos += 1
            }
        }

    }
    if union {
        ranges.append(contentsOf: parts)
    }
}

let count2 = ranges.reduce(0) {$0 + $1.reduce(1){$0 * ($1.upperBound - $1.lowerBound+1)}}
print("Day22_2:\(count2)")
