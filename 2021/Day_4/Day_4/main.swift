//
//  main.swift
//  Day_4
//
//  Created by Pavlo Liashenko on 04.12.2021.
//

import Foundation

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL)
var dataBloks = inputFileData.components(separatedBy:"\n\n")
var numbers = dataBloks[0].components(separatedBy:",").map{Int($0)!}
dataBloks.removeFirst()
var cards = dataBloks.map{$0.split(separator:"\n").map{$0.split(separator:" ").map{Int($0)!}}}
var clear_cards = cards
var wins = Set<Int>()
for number in numbers {
    for (i, card) in cards.enumerated() {
        let card = card.map {
            $0.map {
                $0 == number ? -1 : $0
            }
        }
        if !wins.contains(i) {
            var cx = 0
            var cy = 0
            for x in 0..<5 {
                cx = 0
                cy = 0
                for y in 0..<5 {
                    cx += card[x][y] == -1 ? 1 : 0
                    cy += card[y][x] == -1 ? 1 : 0
                }
                if (cx == 5 || cy == 5) {
                    wins.insert(i)
                    if wins.count == 1 || wins.count == cards.count {
                        let sum = card.reduce(0) {
                            $0 + $1.reduce(0) {
                                $0 + ($1 == -1 ? 0 : $1)
                            }
                        }
                        print("Day_4_\(wins.count == 1 ? "1" : "2"): \(sum*number)")
                    }
                    break
                }
            }
        }
        
        cards[i] = card
    }
}
