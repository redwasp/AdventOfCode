//
//  main.swift
//  Day_1
//
//  Created by Pavlo Liashenko on 14.12.2023.
//

import Foundation

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL).trimmingCharacters(in:.whitespacesAndNewlines)
let modules = inputFileData.components(separatedBy: .newlines).map{Int($0)!}

var result1 = modules.reduce(into: 0) {sum, mass in
    sum += mass/3 - 2
}
print("Day_1_1: \(result1)")

var result2 = modules.reduce(into: 0) {sum, mass in
    var mass = mass
    repeat {
        mass = mass/3 - 2
        sum += mass
    } while mass > 8
}

print("Day_1_2: \(result2)")
