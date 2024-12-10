//
//  main.swift
//  Day_9
//
//  Created by Pavlo Liashenko on 07.08.2022.
//

import Foundation


let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL)
var data = inputFileData.trimmingCharacters(in: .whitespacesAndNewlines)

var items : [Item] = []

class Item : CustomStringConvertible {
    var value: String
    var size : Int
    
    init(_ value: String) {
        self.value = value
        self.size  = value.count
    }
    
    var description: String {"\(value)"}
}

class Marker : Item {
    var length : Int
    var count  : Int
    override init(_ value: String) {
        let marker = value.dropFirst().dropLast()
        let args = marker.components(separatedBy:"x").map{Int($0)!}
        self.length = args[0]
        self.count = args[1]
        super.init(value)
    }
}

while data.count != 0 {
    if data.first == "(" {
        let end = data.firstIndex(of:")")!
        let marker = data[...end]
        items.append(Marker(String(marker)))
        data.removeSubrange(...end)
    } else {
        let end = data.firstIndex(of:"(") ?? data.endIndex
        let text = data[..<end]
        items.append(Item(String(text)))
        data.removeSubrange(..<end)
    }
}

func calc1(of items: [Item]) -> Int {
    var items = items
    var result = 0
    while items.count != 0 {
        let item = items.removeFirst()
        if let marker = item as? Marker {
            var length = marker.length
            var index = 0
            while length != 0 {
                length -= items[index].size
                index += 1
            }
            let itemsSize =  marker.count * marker.length
            items.removeSubrange(..<index)
            result += itemsSize
        } else {
            result += item.size
        }
    }
    return result
}

func calc2(of items: [Item]) -> Int {
    var items = items
    var result = 0
    while items.count != 0 {
        let item = items.removeFirst()
        if let marker = item as? Marker {
            var length = marker.length
            var index = 0
            while length != 0 {
                length -= items[index].size
                index += 1
            }
            let block = Array(items[..<index])
            items.removeSubrange(..<index)
            let itemsSize =  marker.count * calc2(of: block)
            result += itemsSize
        } else {
            result += item.size
        }
    }
    return result
}


print("Day_9_1: \(calc1(of: items))")//150914
print("Day_9_2: \(calc2(of: items))")//11052855125
