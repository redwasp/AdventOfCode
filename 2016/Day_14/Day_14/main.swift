//
//  main.swift
//  Day_14
//
//  Created by Pavlo Liashenko on 15.08.2022.
//

import Foundation
import CryptoKit

struct Key : CustomStringConvertible {
    let index : Int
    let char  : Character
    let value : String
    
    var description: String {
        "\(index) \(char) \(value)"
    }
}


let salt = "ahsbgdzn"
let data = salt.data(using: .utf8)!
var exit = false
var index = -1
var candidats : [Key] = []
var valid : [Key] = []

var bytes : [UInt8] = []
let range : ClosedRange<UInt8> = 0...255
for x in range {
    bytes.append(contentsOf: String(format: "%02hhx", x).data(using: .utf8)!.map{$0})
}
print("\(bytes)")

while !exit {//TODO: optimise
    index += 1
    var str = salt + String(index)
    var data = str.data(using:.utf8)!
    if index % 1000 == 0 {
        print("\(index) \(valid.count)")
    }
    var hash = Insecure.MD5.hash(data: data)
    var array : [UInt8] = []
    
    for index in 0..<2017 {
        hash  = Insecure.MD5.hash(data: data)
        array = []
        for x in hash {
            let x = Int(x)
            array.append(bytes[2*x])
            array.append(bytes[2*x+1])
        }
        data = Data(array)
    }

    str = String(data: data, encoding: .utf8)! + "*"
    if index == 22551 {
        print("\(str)")
    }
//    print("\(str)")

    
    var prev : Character? = nil
    var count = 1
    for char in str {
        if char == prev {
            count += 1
           
        } else {

            if count >= 5 {
                var i = 0
                while i < candidats.count {
                    if candidats[i].char == prev! {
                        valid.append(candidats.remove(at: i))
                        print("\(valid.count) \(valid.last!) \(index)")

                    } else {
                        i += 1
                    }
                }
            }
            if count >= 3 {
                if candidats.last?.value != str {
                    candidats.append(Key(index: index, char: prev!, value: str))
                }
                break
            }
            count = 1
        }

        prev = char
    }
    while candidats.count > 0 && candidats.first!.index < (index - 1000) {
        let x = candidats.removeFirst()
        //print("- \(x) [\(index)]")
    }
    if valid.count >= 80 {
        exit = true
    }
}
valid.sort { $0.index < $1.index}
print("\(valid[64-1])")
//22628 low
//22696
//23478 hight

//
//while !exit {//TODO: optimise
//    index += 1
//    let data = data + String(index).data(using:.utf8)!
//    let hash = Insecure.MD5.hash(data: data)
//    let str = hash.map { String(format: "%02hhx", $0) }.joined() + "*"
//    var prev : Character? = nil
//    var count = 1
//    for char in str {
//        if char == prev {
//            count += 1
//
//        } else {
//
//            if count >= 5 {
//                var i = 0
//                while i < candidats.count {
//                    if candidats[i].char == prev! {
//                        valid.append(candidats.remove(at: i))
//                        print("\(valid.count) \(valid.last!) \(index)")
//
//                    } else {
//                        i += 1
//                    }
//                }
//            }
//            if count >= 3 {
//                if candidats.last?.value != str {
//                    candidats.append(Key(index: index, char: prev!, value: str))
//                }
//                break
//            }
//            count = 1
//        }
//
//        prev = char
//    }
//    while candidats.count > 0 && candidats.first!.index < (index - 1000) {
//        let x = candidats.removeFirst()
//        //print("- \(x) [\(index)]")
//    }
//    if valid.count >= 256 {
//        exit = true
//    }
//}
//valid.sort { $0.index < $1.index}
//print("\(valid[64-1])")
