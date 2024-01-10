//
//  main.swift
//  Day_7
//
//  Created by Pavlo Liashenko on 07.12.2023.
//

import Foundation

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL)
                        .trimmingCharacters(in: .whitespacesAndNewlines)

var ranks : [Character : Int] =
["2": 2,
 "3": 3,
 "4": 4,
 "5": 5,
 "6": 6,
 "7": 7,
 "8": 8,
 "9": 9,
 "T": 10,
 "J": 11,
 "Q": 12,
 "K": 13,
 "A": 14];

print("Day_7_1: \(winnings(isJokersAvailable: false))")//246163188

ranks["J"] = 1
print("Day_7_2: \(winnings(isJokersAvailable: true))")//245794069

func winnings(isJokersAvailable: Bool) -> Int {
    let items = inputFileData
                .components(separatedBy: .newlines)
                .map {Item($0, isJokersAvailable)}
                .sorted()
    var total = 0;
    for index in 0..<items.count {
        let item = items[index]
        total += (index + 1)*item.bid
    }
    return total
}

struct Item : Comparable {
    let cards: Array<Character>
    let bid: Int
    let type: HandType
    
    init(_ string: String, _ isJokersAvailable: Bool = false) {
        let parts = string.components(separatedBy: .whitespaces)
        cards = parts[0].map{$0}
        bid = Int(parts[1])!
        type = HandType(by: cards, isJokersAvailable)
    }
    
    static func < (lhs: Item, rhs: Item) -> Bool {
        if lhs.type == rhs.type {
            for index in 0..<5 {
                let lcard = lhs.cards[index]
                let rcard = rhs.cards[index]
                guard lcard != rcard else {continue}
                return ranks[lcard]! < ranks[rcard]!
            }
        }
        return lhs.type < rhs.type
    }
}

extension Item {
    enum HandType: Int, Comparable {
        
        case highCard
        case onePair
        case twoPair
        case threeOfKind
        case fullHouse
        case fourOfKind
        case fiveOfKind
        
        init(by cards: Array<Character>, _ isJokersAvailable: Bool = false) {
            var map = cards.reduce(into: [Character: Int]()) {
                $0[$1] = ($0[$1] ?? 0) + 1
            }
            if isJokersAvailable,
               let jCount = map["J"] {
                map["J"] = nil
                if jCount == 5 {
                    map["A"] = 5
                } else if jCount == 4 {
                    map[map.first!.key] = 5
                } else {
                    let max = map.max { lhs, rhs in
                        if lhs.value == rhs.value {
                            ranks[lhs.key]! < ranks[rhs.key]!
                        } else {
                            lhs.value < rhs.value
                        }
                    }
                    map[max!.key] = max!.value + jCount
                }
            }
            let cards = map.map {
                (card: $0.key, count: $0.value)
            }.sorted {
                $0.count > $1.count
            }
          
            if (cards[0].count == 5) {
                self = .fiveOfKind
            } else if (cards[0].count == 4) {
                self = .fourOfKind
            } else if (cards[0].count == 3 && cards[1].count == 2) {
                self = .fullHouse
            } else if (cards[0].count == 3) {
                self = .threeOfKind
            } else if (cards[0].count == 2 && cards[1].count == 2) {
                self = .twoPair
            } else if (cards[0].count == 2) {
                self = .onePair
            } else {
                self = .highCard
            }
            
        }
        static func < (lhs: Item.HandType, rhs: Item.HandType) -> Bool {
            lhs.rawValue < rhs.rawValue
        }
    }
}
