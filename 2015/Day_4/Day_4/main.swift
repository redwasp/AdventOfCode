//
//  main.swift
//  Day_4
//
//  Created by Pavlo Liashenko on 17.05.2022.
//

import Foundation
import CryptoKit


let key = "yzbqklnj"
let keyData = key.data(using: .utf8)!
var exit = false
var index = 0
var target = 5
var skip = false
while !exit {
    index += 1
    let data = keyData + String(index).data(using:.utf8)!
    let hash = Insecure.MD5.hash(data: data)
    var count = 0
    for i in hash {
        if  i == 0 {
            count += 2
        } else if !skip {
            count += i.leadingZeroBitCount/4
        } else {
            break;
        }
        
        if count >= target {
            let str = hash.map { String(format: "%02hhx", $0) }.joined()
            print("Day4_\(target-4) : \(str) : \(index)")
            if target == 6 {
                exit = true
            } else {
                target += 1
                skip = true
            }
            break
        }
        if i != 0 {
            break
        }
    }
}
