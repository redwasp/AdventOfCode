//
//  main.swift
//  Day_15
//
//  Created by Pavlo Liashenko on 15.12.2023.
//

import Foundation

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL).trimmingCharacters(in: .whitespacesAndNewlines)
let steps = inputFileData.components(separatedBy:",")

func HASH(_ string: String) -> Int {
    string.reduce(0) {
        (($0 + Int($1.asciiValue!)) * 17) % 256
    }
}

let result1 = steps.reduce(0) {
    $0 + HASH($1)
}
print("Day_15_1: \(result1)")//515495

var boxes : [[(label: String, length: Int)]] = Array(repeating: [], count: 256)
for step in steps {
    if step.hasSuffix("-") {
        let key = String(step.dropLast())
        let boxIndex = HASH(key)
        guard let lensIndex = boxes[boxIndex].firstIndex(where:{$0.label == key}) else {continue}
        boxes[boxIndex].remove(at:lensIndex)
    } else {
        let comps = step.components(separatedBy:"=")
        let key = comps[0]
        let value = Int(comps[1])!
        let boxIndex = HASH(key)
        if let lensIndex = boxes[boxIndex].firstIndex(where:{$0.label == key}) {
            boxes[boxIndex][lensIndex] = (key, value)
        } else {
            boxes[boxIndex].append((key, value))
        }
    }
}

var power = 0
for (boxIndex, box) in boxes.enumerated() {
    for (lensIndex, lens) in box.enumerated() {
        power += (boxIndex+1)*(lensIndex+1)*lens.length
    }
}

print("Day_16_1: \(power)")//229349
