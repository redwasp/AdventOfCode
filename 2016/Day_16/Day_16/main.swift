//
//  main.swift
//  Day_16
//
//  Created by Pavlo Liashenko on 19.08.2022.
//

import Foundation

let input = "01111010110010011"
let size = 272
let data = input.map{ $0 == "1"}

func process(_ data: [Bool], _ size: Int) -> String {
    var data = data
    while data.count < size {
        let part = data.map{!$0}.reversed()
        data.append(false)
        data.append(contentsOf: part)
        //print("\(data.map{$0 ? "1" : "0"}.joined())")
    }
    data = Array(data[..<size])
    while data.count % 2 == 0 {
        var checksum : [Bool] = []
        for i in 0..<data.count/2 {
            checksum.append(data[i*2] == data[i*2 + 1])
        }
        data = checksum
    }
    
    return data.map{$0 ? "1" : "0"}.joined()
}
print("\(process(data, size))")

let size2 = 35651584
print("\(process(data, size2))")
