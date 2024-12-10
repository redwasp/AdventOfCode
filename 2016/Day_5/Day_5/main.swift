//
//  main.swift
//  Day_5
//
//  Created by Pavlo Liashenko on 29.07.2022.
//

import Foundation
import CryptoKit

let doorID = "wtnhxymk"
let data = doorID.data(using: .utf8)!

var index = 0
var res1 = ""
var map : [UInt8: UInt8] = [:]
var exit = false
while res1.count != 8 || map.count != 8 {//TODO: optimise
    index += 1
    let data = data + String(index).data(using:.utf8)!
    let hash = Insecure.MD5.hash(data: data)
    let bytes = Data(hash)
    if bytes[0] == 0 && bytes[1] == 0 && (bytes[2] & 0x0F == bytes[2])  {
        if res1.count < 8 {
            res1 += String(bytes[2], radix: 16)
        }
        if bytes[2] < 8 && map[bytes[2]] == nil {
            map[bytes[2]] = bytes[3]>>4
        }
    }
}
print("Day_5_1: \(res1)")

var res2 = ""
for index in UInt8(0)...UInt8(7) {
    res2 += String(map[index]!, radix: 16)
}
print("Day_5_2: \(res2)")

