//
//  main.swift
//  Day_15
//
//  Created by Pavlo Liashenko on 29.06.2022.
//

import Foundation

struct Ingredient : CustomStringConvertible {
    let name : String
    let properties : [Property]
    struct Property : CustomStringConvertible {
        let name : String
        let value : Int
        var description: String {
            "\(name) = \(value)"
        }
    }
    
    init(_ string : String) {
        let components = string.components(separatedBy:": ")
        self.name = String(components[0])
        self.properties = components[1].components(separatedBy: ", ").map{
            let parts = $0.components(separatedBy:" ")
            return Property(name: String(parts[0]), value: Int(parts[1])!)
        }

    }
    var description: String {
        "\(name): \(properties.map{$0.description}.joined(separator:", "))"
    }

}

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL)
let lines = inputFileData.split(separator: "\n", omittingEmptySubsequences: true)
let ingredients = lines.map{Ingredient(String($0))}
//print("\(ingredients)")
//print("\(ingredients[0].properties)")
let properties = ingredients[0].properties

let size = 100
var max = 0
for i1 in 1...size-3 {
    for i2 in 1...size-i1-2 {
        for i3 in 1...size-i1-i2-1 {
            let i4 = size-i1-i2-i3
            let vector = [i1, i2, i3, i4]
            var mul = 1
            for propertyIndex in 0..<4 {
                var sum  = 0
                for ingredientIndex in 0..<4 {
                    let property = ingredients[ingredientIndex].properties[propertyIndex]
                    let count = vector[ingredientIndex]
                    sum += count*property.value
                }
                if sum < 0 {
                    sum = 0
                }
                mul *= sum
            }
            if mul > max {
                max = mul
               // print("\(vector)")
            }
        }
    }
}

print("Day_15_1: \(max)")

max = 0
for i1 in 1...size-3 {
    for i2 in 1...size-i1-2 {
        for i3 in 1...size-i1-i2-1 {
            let i4 = size-i1-i2-i3
            let vector = [i1, i2, i3, i4]
            var mul = 1
            var kall = 0
            for index in 0..<4 {
                let count = vector[index]
                kall += count * ingredients[index].properties.last!.value
            }
            guard kall == 500 else {continue}
            for propertyIndex in 0..<4 {
                var sum  = 0
                for ingredientIndex in 0..<4 {
                    let property = ingredients[ingredientIndex].properties[propertyIndex]
                    let count = vector[ingredientIndex]
                    sum += count*property.value
                }
                if sum < 0 {
                    sum = 0
                }
                mul *= sum
            }
            if mul > max {
                max = mul
                //print("\(vector)")
            }
        }
    }
}
print("Day_15_2: \(max)")

