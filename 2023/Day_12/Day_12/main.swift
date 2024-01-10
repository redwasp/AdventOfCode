//
//  main.swift
//  Day_12
//
//  Created by Pavlo Liashenko on 12.12.2023.
//

import Foundation

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL).trimmingCharacters(in: .whitespacesAndNewlines)
var records = inputFileData.components(separatedBy:.newlines).map{Record($0)}

struct Record : Hashable {
    var template: Springs
    var values: [Int]
    
    init(_ row: String) {
        let comp = row.components(separatedBy:.whitespaces)
        template = comp[0].map{Spring($0)}
        values = comp[1].components(separatedBy:",").map{Int($0)!}
    }
    
    func unfold(_ factor: Int) -> Record {
        var record = self
        if (factor > 1) {
            record.template = Array(Array(repeating: record.template, count: factor).joined(separator:[Spring.unknow]))
            record.values   = Array(Array(repeating: record.values,   count: factor).joined())
        }
        return record
    }
}

enum Spring {
    case unknow
    case operational
    case damaged
    init(_ char: Character) {
        switch char {
        case "?":
            self = .unknow
        case "#":
            self = .damaged
        default:
            self = .operational
        }
    }
}

typealias Springs = [Spring]

var cashe: [Record: Int] = [:]

func arrangements(for record: Record) -> Int {
    if let result = cashe[record] {
        return result
    }
    let values = record.values.reduce(0, +)
    guard values != 0 else {
        for item in record.template {
            guard item != .damaged else {return 0}
        }
        return 1
    }
    guard values <= record.template.count else {
        return 0
    }
    let template = record.template
    var newRecord = record
    let item = newRecord.values.removeFirst()
    var valid = false
    var sum = 0
    for position in 0..<newRecord.template.count - item+1 {
        guard position == 0 || template[position-1] != .damaged else {
            break
        }
        guard template[position] != .operational else {continue}
        valid = true
        for index in position..<position + item {
            guard template[index] != .operational else {
                valid = false
                break
            }
        }
        guard valid else {continue}
        guard template.count == position + item || template[position + item] != .damaged else {
            continue
        }
        var template = template
        for i in position..<position+item {
            template[i] = .damaged
        }
        newRecord.template = Array(template.suffix(from: position + item))
        if newRecord.template.count > 0 {
            newRecord.template = Array(newRecord.template.dropFirst())
        }
        sum += arrangements(for: newRecord)
    }
    cashe[record] = sum;
    return sum
}

func process(factor: Int = 1) -> Int {
    records.map { record in
        arrangements(for: record.unfold(factor))
    }.reduce(0, +)
}

print("Day_12_1: \(process())")//7090
print("Day_12_2: \(process(factor: 5))")//6792010726878
