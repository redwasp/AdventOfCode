//
//  main.swift
//  Day_16
//
//  Created by Pavlo Liashenko on 16.12.2021.
//

import Foundation

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL).trimmingCharacters(in: .whitespacesAndNewlines)
let data : [[Bool]] = inputFileData.map{
            String($0.hexDigitValue!, radix: 2, uppercase: false)
}.map{$0.map{Bool($0=="1")}}.map {
    var bits = $0
    while bits.count != 4 {
        bits.insert(false, at: 0)
    }
    return bits
}
let packet = data.reduce(into: [Bool]()) { $0.append(contentsOf: $1)}
pr(packet)

func pr(_ packet : [Bool]) {
    var str = ""
    for bit in packet {
        str += bit ? "1" : "0";
    }
    print(str)
}

func num(_ packet : ArraySlice<Bool>) -> Int {
    var num = 0
    for bit in packet {
        num <<= 1
        if bit {
            num += 1
        }
    }
     //print("X:\(String(num, radix: 2, uppercase: false)) = \(num)")
    return num
}

func num(_ packet : [Bool]) -> Int {
    num(packet[...])
}
var verSum = 0

func read(_ packet : ArraySlice<Bool>, _ pos: inout Int) -> Int {
    let version = num(packet[pos..<(pos+3)])
    verSum += version
    let typeID  = num(packet[(pos+3)..<(pos+6)])
    print(" V:\(version)\rID:\(typeID)")
    pos += 6
    if typeID == 4 {
        var bit : Bool!
        var array : [Bool] = []
        repeat {
            bit = packet[pos]
            pos += 1
            array.append(contentsOf:packet[pos..<(pos+4)])
            pos += 4
        } while bit
        return num(array)
    } else {
        var numbers : [Int] = []
        let lengthTypeID = packet[pos]
        pos += 1
        if lengthTypeID {
            let subpacketsNumber = num(packet[pos..<(pos+11)])
            pos += 11
            for _ in 0..<subpacketsNumber {
                let number = read(packet[pos...], &pos)
                numbers.append(number)
            }
        } else {
            let subpacketsLength = num(packet[pos..<(pos+15)])
            pos += 15
            let offset = pos
            while pos - offset < subpacketsLength {
                let number = read(packet[pos...], &pos)
                numbers.append(number)
            }
        }
        switch typeID {
        case 0:
            return numbers.reduce(0, +)
        case 1:
            return numbers.reduce(1, *)
        case 2:
            return numbers.min()!
        case 3:
            return numbers.max()!
        case 5:
            return numbers[0]>numbers[1] ? 1 : 0
        case 6:
            return numbers[0]<numbers[1] ? 1 : 0
        case 7:
            return numbers[0]==numbers[1] ? 1 : 0
        default:
            print("Error")
        }
        print("XXX")
        return 0
    }
}

var pos = 0
let x = read(packet[...], &pos)
print("Day16_1:\(verSum)")
print("Day16_2:\(x)")

