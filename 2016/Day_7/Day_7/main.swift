//
//  main.swift
//  Day_7
//
//  Created by Pavlo Liashenko on 02.08.2022.
//

import Foundation

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL)
var lines = inputFileData.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines)

func isSupportTLS(_ ip: String) -> Bool {
    let ip = ip.map{$0}
    let count = ip.count
    var index = 0
    var isOpen = false
    var support = false
    while index < count-3 {
        if ip[index] == "[" {
            isOpen = true
        } else  if ip[index] == "]" {
            isOpen = false
        } else if ip[index]   == ip[index+3],
                  ip[index+1] == ip[index+2],
                  ip[index]   != ip[index+1]
        {
            if isOpen {
                return false
            } else {
                support = true
            }
        }
        index += 1
    }

    return support
}

let count = lines.reduce(into: 0) {$0 += isSupportTLS($1) ? 1 : 0}
print("Day_7_1: \(count)")


func isSupportSSL(_ ip: String) -> Bool {
    let ip = ip.map{$0}
    let count = ip.count
    var index = 0
    var isOpen = false
    var supernet : Set<String> = []
    var hypernet : Set<String> = []
    while index < count-2 {
        if ip[index] == "[" {
            isOpen = true
        } else  if ip[index] == "]" {
            isOpen = false
        } else if ip[index] == ip[index+2] {
            if isOpen {
                hypernet.insert(String(ip[index...(index+2)]))
            } else {
                supernet.insert(String([ip[index+1],ip[index],ip[index+1]]))
            }
        }
        index += 1
    }
    
    let intersection = hypernet.intersection(supernet)
    return intersection.count >= 1
}

let count2 = lines.reduce(into: 0) {$0 += isSupportSSL($1) ? 1 : 0}
print("Day_7_2: \(count2)")
