//
//  main.swift
//  Day_4
//
//  Created by Pavlo Liashenko on 28.07.2022.
//

import Foundation

struct Room : CustomStringConvertible {
    let name     : [String]
    let sectorID : Int
    let checksum : String
    
    init(_ string: String) {
        var components = string.components(separatedBy:"[")
        checksum = String(components.last!.dropLast())
        components = components.first!.components(separatedBy:"-")
        sectorID = Int(components.removeLast())!
        name = components
    }
    
    var description: String {
        return "\(name) \(sectorID) \(checksum)"
    }
    
    var isValid : Bool {
        var counts : [Character : Int] = [:]
        for item in name {
            for char in item {
                counts[char, default: 0] += 1
            }
        }
        let string = String(counts.sorted{$0.value > $1.value || ($0.value == $1.value && $0.key < $1.key)}.map{$0.key}.prefix(5))
        return string == checksum
    }
    
    var encripted : [String] {
        var newName : [String] = []
        let loopSize = UInt32(26)
        let maxValue = "z".unicodeScalars.first!.value
        let offset = UInt32(sectorID) % loopSize
        for item in name {
            var newItem = ""
            for char in item {
                var value = char.unicodeScalars.first!.value + offset
                if value > maxValue {
                    value -= loopSize
                }
                newItem += String(UnicodeScalar(value)!)
            }
            newName.append(newItem)
        }
        return newName
    }
}

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL)
var rooms = inputFileData.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy:.newlines).map{Room($0)}

//Part #1
let sum = rooms.reduce(into: 0){$0 += $1.isValid ? $1.sectorID : 0}
print("Day_4_1: \(sum)")//185371

//Part #2
for room in rooms {
    if room.encripted.first!.hasPrefix("north") {
        print("Day_4_2: \(room.sectorID)")//984
        break
    }
}

