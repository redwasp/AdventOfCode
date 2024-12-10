//
//  main.swift
//  Day_2
//
//  Created by Pavlo Liashenko on 23.03.2024.
//

import Foundation

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL).trimmingCharacters(in: .whitespacesAndNewlines)
let lines = inputFileData.split(separator: "\n" )

for lineIndex1 in 0..<lines.count {
    for lineIndex2 in lineIndex1+1..<lines.count {
        let line1 = lines[lineIndex1]
        let line2 = lines[lineIndex2]
        var differences = 0
        for charIndex in 0...line1.count-1 {

            let ls1 = line1[line1.index(line1.startIndex, offsetBy:charIndex)]
            let ls2 = line2[line2.index(line2.startIndex, offsetBy:charIndex)]

            if ls1 != ls2 {
                differences += 1;
            }
            if (differences > 1) {
                break;
            }
        }
        if differences == 1 {
            print("Day_2_2: \(line1)");
        }
    }
}

