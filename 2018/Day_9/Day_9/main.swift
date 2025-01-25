//
//  main.swift
//  Day_9
//
//  Created by Pavlo Liashenko on 17.01.2023.
//

import Foundation

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL).trimmingCharacters(in: .whitespacesAndNewlines)
let words = inputFileData.components(separatedBy:.whitespaces)

let players = Int(words[0])!
let points  = Int(words[6])!
let xPoints = points

func process(_ players : Int,  _ points: Int) -> Int {
    var score : [Int] = Array(repeating: 0, count: players)
    var circle : [Int] = [0];//Array(repeating: 0, count: points)
    
    var index = 0
    var size = 1
    for i in 1...points {
        if i%23 != 0 {
            index += 2
            while (index >= size + 1) {
                index -= size;
            }
            circle.insert(i, at: index)
            size += 1
        } else {
            index -= 7;
            if index < 0 {
                index += size;
            }
            let player = (i-1)%players;
            print("P:\(player) +\(circle[index] + i) = \(circle[index]) \(i)")
            score[player] += circle[index] + i;
            circle.remove(at: index)
            size -= 1
        }
        if i % xPoints == 0 {
            let max = score.max()!
            print("\(score.firstIndex(of: max)!) \(max)")
        }
    }
    return score.max()!
}

print("Day_9_1:\(process(players, points))");
print("Day_9_2:\(process(players, points*100))");

//197 = 374690
