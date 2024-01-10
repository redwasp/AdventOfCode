//
//  main.swift
//  Day_5
//
//  Created by Pavlo Liashenko on 05.12.2023.
//

import Foundation

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL)
                        .trimmingCharacters(in: .whitespacesAndNewlines)
let parts = inputFileData
    .components(separatedBy:"\n\n")
let seeds = parts[0]
    .components(separatedBy:":")[1]
    .components(separatedBy:.whitespaces)
    .compactMap {
        Int($0)
    }
let maps = parts
    .dropFirst()
    .map {
        $0.components(separatedBy:.newlines)
        .dropFirst()
        .map {
            $0.components(separatedBy: .whitespaces)
            .map {
                Int($0)!
            }
        }
    }
var locations : [Int] = []
for seed in seeds {
    var seed = seed
    for map in maps {
        for range in map {
            let destenation = range[0]
            let source = range[1]
            let length = range[2]
            let offset = destenation - source
            if source <= seed && seed < source + length {
                seed += offset
                break;
            }
        }
    }
    locations.append(seed)
}
let result1 = locations.min()!
print("Day_5_1: \(result1)")//579439039

var seedRanges : Array<Range<Int>> = []
for n in 0..<seeds.count/2 {
    seedRanges.append(seeds[2*n]..<(seeds[2*n]+seeds[2*n+1]))
}

locations = []
for seedRange in seedRanges {
    var ranges = [seedRange]
    for map in maps {
        var newRanges : Array<Range<Int>> = []
        for range in ranges {
            var range = range
            for mapRange in map {
                let destenation = mapRange[0]
                let source = mapRange[1]
                let length = mapRange[2]
                let offset = destenation - source
                let sourceRange = source..<(source+length)
                if range.overlaps(sourceRange) {
                    if (sourceRange.contains(range.lowerBound) && sourceRange.contains(range.upperBound)) {
                        newRanges.append(range.lowerBound+offset..<range.upperBound+offset)
                        range = 0..<0
                        break;
                    } else if sourceRange.contains(range.lowerBound) {
                        newRanges.append(range.lowerBound+offset..<source+length+offset)
                        range = source+length..<(range.upperBound)
                    } else if sourceRange.contains(range.upperBound) {
                        newRanges.append(source+offset..<range.upperBound+offset)
                        range = range.lowerBound..<source
                    }
                }
            }
            if (!range.isEmpty) {
                newRanges.append(range)
            }
        }
        ranges = newRanges
    }
    let min = ranges.map{$0.lowerBound}.min()!
    locations.append(min)
}
let result2 = locations.min()!
print("Day_5_2: \(result2)")//7873084

