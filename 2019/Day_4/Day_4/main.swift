//
//  main.swift
//  Day_4
//
//  Created by Pavlo Liashenko on 1/28/25.
//

import Foundation

let input = 165432..<707912
let input1 = 193651..<649729
let range = input

func isValid1(_ n: Int) -> Bool {
    var result = false
    var p = 10
    var n = n
    while n != 0 {
        let d = n%10
        if d > p {
            return false
        } else if d == p {
            result = true
        }
        p = d
        n /= 10
    }
    return result
}

func isValid2(_ n: Int) -> Bool {
    var result = false
    var pairs = 0
    var p = 10
    var n = n
    while n != 0 {
        let d = n%10
        if d > p {
            return false
        } else if !result {
            if d == p {
                pairs += 1
            } else {
                if pairs == 1 {
                    result = true
                }
                pairs = 0
            }
        }
        p = d
        n /= 10
    }
    return result || pairs == 1
}


let result1 = range.reduce(0){$0 + (isValid1($1) ? 1 : 0)}
print("Day_4_1:", result1)

let result2 = range.reduce(0){$0 + (isValid2($1) ? 1 : 0)}
print("Day_4_2:", result2)
