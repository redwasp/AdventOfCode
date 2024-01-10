//
//  main.swift
//  Day_12
//
//  Created by Pavlo Liashenko on 08.06.2022.
//

import Foundation

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL)
let data = try JSONSerialization.jsonObject(with: Data(contentsOf: inputFileURL), options: .mutableContainers)

func sum(_ a: Any) -> Int {
    switch a {
    case let dictionary as Dictionary<AnyHashable, Any>:
        return dictionary.reduce(into: 0){$0 += sum($1.value)}
    case let array as Array<Any>:
        return array.reduce(into: 0){$0 += sum($1)}
    case let value as Int:
        return value
    case is String:
        return 0
    default:
        return 0
    }
}

print("Day12_1: \(sum(data))")

func sum2(_ a: Any) -> Int {
    switch a {
    case let dictionary as Dictionary<AnyHashable, Any>:
        if dictionary.values.contains(where: {$0 as? String == "red"}) {
            return 0
        } else {
            return dictionary.reduce(into: 0){$0 += sum2($1.value)}
        }
    case let array as Array<Any>:
        return array.reduce(into: 0){$0 += sum2($1)}
    case let value as Int:
        return value
    case is String:
        return 0
    default:
        return 0
    }
}

print("Day12_2: \(sum2(data))")
