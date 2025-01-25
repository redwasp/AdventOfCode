//
//  main.swift
//  Day_7
//
//  Created by Pavlo Liashenko on 12.09.2022.
//

import Foundation

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL)
var lines = inputFileData.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines)
var tree : [String : Any] = [:]
var namesSet = Set<String>()
var childsSet = Set<String>()
var set =  CharacterSet(charactersIn:"()")
var set2 =  CharacterSet(charactersIn:",")

for line in lines {
    let components = line.split(separator: " ")
    var item : [String : Any] = [:]
    let name = String(components[0])
    let weight = Int(components[1].trimmingCharacters(in:set))!
    item["name"] = name
    item["weight"] = weight
    namesSet.insert(name)
    if (components.count > 2) {
        let childs = components[3...]
        let childNames = childs.map({ (str) -> String in
            return String(str.trimmingCharacters(in:set2))
        })
        item["childs"] = childNames
        childsSet.formUnion(childNames)
    }
    tree[name] = item
}

var unicum = namesSet.subtracting(childsSet)

print("Day_7_1: \(unicum.first!)")

var result = 0
@discardableResult func sumWeight(name: String) -> Int {
    guard result == 0 else {return 0}
    let item = tree[name] as! [String : Any]
    let weight = item["weight"] as! Int
    var sum = weight
    if let childs = item["childs"] as? [String] {
        let childsWeight = childs.map{sumWeight(name:$0)}
        guard result == 0 else {return 0}
        var set = Set(childsWeight)
        if set.count > 1 {
            let itemsCount = childsWeight.reduce(into: [Int: Int]()) { $0[$1, default:0] += 1}
            let badItemValue = itemsCount.min{$0.value < $1.value}!.key
            set.remove(badItemValue)
            let goodItemValue = set.first!
            let badItemIndex = childsWeight.firstIndex(of:badItemValue)!
            let badItemName = childs[badItemIndex]
            let badItem = tree[badItemName] as! [String : Any]
            let badItemWeight = badItem["weight"] as! Int
            result = badItemWeight - (badItemValue - goodItemValue)
            return 0
        }
        sum += childsWeight.reduce(0, +)
    }
    
    return sum
}

sumWeight(name:unicum.first!)
print("Day_7_2: \(result)")
