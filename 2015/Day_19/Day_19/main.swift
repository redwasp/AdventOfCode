//
//  main.swift
//  Day_19
//
//  Created by Pavlo Liashenko on 14.06.2022.
//

import Foundation

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL)
var lines = inputFileData.split(separator: "\n", omittingEmptySubsequences: true)
let molecule = String(lines.removeLast())
let replacements = lines.map{$0.components(separatedBy: " => ")}.sorted { $0[1].count > $1[1].count}
var molecules : Set<String> = []
for replacement in replacements {
    var index = molecule.startIndex
    while let range = molecule.range(of: replacement[0], options: .literal, range: index..<molecule.endIndex) {
        let newMolecule = molecule.replacingCharacters(in:range, with: replacement[1])
        molecules.insert(newMolecule)
        index = range.upperBound
    }
}

print("Day19_1: \(molecules.count)")

var minStep = Int.max
func find(_ molecule: String, _ steps: Int) {
    guard steps < minStep else {return}
    if molecule != "e" {
        if steps > minStep {return}
        for replacement in replacements {
            var index = molecule.startIndex
            while let range = molecule.range(of: replacement[1], options: .literal, range: index..<molecule.endIndex) {
                let newMolecule = molecule.replacingCharacters(in: range, with: replacement[0])
                find(newMolecule, steps+1)
                index = range.upperBound
            }
        }
    } else {
        minStep = steps
        print("Day19_2: \(minStep)")
    }
}
find(molecule, 0)
print("Day19_2: \(minStep)")

func find() -> Int {
    var variants : [String] = [molecule]
    var step = 0

    while variants.count > 0 {
        step += 1
        var newVariants : Set<String> = []
        for molecule in variants {
            for replacement in replacements {
                var index = molecule.startIndex
                while let range = molecule.range(of: replacement[1], options: .literal, range: index..<molecule.endIndex) {
                    let newMolecule = molecule.replacingCharacters(in: range, with: replacement[0])
                    index = range.upperBound
                    newVariants.insert(newMolecule)
                    if (newMolecule == "e") {
                        return step
                    }
                }
            }
        }
        variants = Array(newVariants)
    }
    return 0
}
