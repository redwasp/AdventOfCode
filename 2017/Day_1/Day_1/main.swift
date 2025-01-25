//
//  main.swift
//  Day_1
//
//  Created by Pavlo Liashenko on 09.09.2022.
//

import Foundation

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL)
var captcha = inputFileData.trimmingCharacters(in: .whitespacesAndNewlines).map{Int(String($0))!}

let count = captcha.count
let offset = captcha.count/2
var sum1 = 0
var sum2 = 0
for index in 0..<count {
    let num = captcha[index]
    if  num == captcha[(index+1) % count] {
        sum1 += num
    }
    if num == captcha[(index+offset) % count] {
        sum2 += num
    }
}
print("Day_1_1:\(sum1)")
print("Day_1_2:\(sum2)")
