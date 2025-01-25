//
//  main.swift
//  Day_13
//
//  Created by Pavlo Liashenko on 16.12.2022.
//

import Foundation

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL).trimmingCharacters(in: .whitespacesAndNewlines)
var pairs = inputFileData.components(separatedBy:"\n\n").map{$0.components(separatedBy:.newlines).map{parce($0)}}

var res = pairs.map{isRight($0)}.enumerated().reduce(into:0){$0 += $1.element ? ($1.offset+1) : 0}
print("Day_13_1: \(res)")

var allPairs = pairs.reduce(into:[AnyHashable]()){$0.append(contentsOf:$1)}
let marker1 = [[2]]
let marker2 = [[6]]
allPairs.append(marker1)
allPairs.append(marker2)
allPairs.sort {isRight([$0,$1])}
let indexMarker1 = allPairs.firstIndex(of: marker1)! + 1
let indexMarker2 = allPairs.firstIndex(of: marker2)! + 1
print("Day_13_2: \(indexMarker1*indexMarker2)")

func parce(_ str: String) -> [AnyHashable] {
    var stack : [AnyHashable] = [[AnyHashable]()]
    var num : String = ""
    for char in str {
        if char.isNumber {
            num.append(char)
        } else if char == "," {
            if num.count > 0 {
                var prev = stack.last as! [AnyHashable]
                prev.append(Int(num)!)
                stack[stack.count-1] = prev
                num = ""
            }
        } else if char == "[" {
            stack.append([AnyHashable]())
        } else if char == "]" {
            if num.count > 0 {
                var prev = stack.last as! [AnyHashable]
                prev.append(Int(num)!)
                stack[stack.count-1] = prev
                num = ""
            }
            let last = stack.removeLast()
            var prev = stack.last as! [AnyHashable]
            prev.append(last)
            stack[stack.count-1] = prev
        }
    }
    return (stack.last as! [AnyHashable]).last as! [AnyHashable]
}

func compare(_ left: [AnyHashable], _ right: [AnyHashable]) -> ComparisonResult {
    let count = min(left.count, right.count)
    for index in 0..<count {
        let l = left[index]
        let r = right[index]
        let ln = l as? Int
        let rn = r as? Int
        if ln != nil && rn != nil {
            if ln == rn {
                continue
            } else {
                //print("\(ln!) > \(rn!) \(ln! > rn!)")
                return ln! > rn! ? .orderedAscending : .orderedDescending
            }
        }
        let newl : [AnyHashable] = (ln == nil ? (l as! [AnyHashable]) : [ln!])
        let newr : [AnyHashable] = (rn == nil ? (r as! [AnyHashable]) : [rn!])
        let res = compare(newl, newr)
        if res == .orderedSame {
            continue
        } else {
            //print("\(newl) > \(newr) \(res != .orderedDescending)")
            return res
        }
    }
    if left.count == right.count {
        return .orderedSame
    } else {
        return left.count > right.count ? .orderedAscending : .orderedDescending
    }
}

func isRight(_ pair: [AnyHashable]) -> Bool {
    let left  = pair[0] as! [AnyHashable]
    let right = pair[1] as! [AnyHashable]
    return compare(left, right) == .orderedDescending
}
