//
//  main.swift
//  Day_5
//
//  Created by Pavlo Liashenko on 1/22/25.
//

import Foundation

let inputFileURL  = URL(fileURLWithPath: "input1.txt")
let inputFileData = try! String(contentsOf: inputFileURL, encoding: .utf8).trimmingCharacters(in: .whitespacesAndNewlines)
let input = inputFileData
let polimer = Array(input)
func react(_ polimer: [Character]) -> [Character] {
    var polimer = polimer
    var index = 0
    while index < polimer.count - 1 {
        let (a, b) = (polimer[index], polimer[index + 1])
        if a != b,
           a.lowercased() == b.lowercased()
        {
            polimer.removeSubrange(index...index+1)
            index -= 1
            if index < 0 {
                index = 0
            }
        } else {
            index += 1
        }
    }
    return polimer
}
print("Day_5_1:", react(polimer).count)

var alphabetLowercased: [Character] = Array("abcdefghijklmnopqrstuvwxyz")
var alphabetUppercased: [Character] = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ")
var minLength = Int.max;
for (toDeleteLowercased, toDeleteUppercased) in zip(alphabetLowercased, alphabetUppercased) {
    let polimer = polimer.filter{$0 != toDeleteLowercased && $0 != toDeleteUppercased}
    minLength = min(minLength, react(polimer).count)
}
print("Day_5_2:", minLength)//6942
