//
//  main.swift
//  Day_21
//
//  Created by Pavlo Liashenko on 15.07.2022.
//

import Foundation

struct Item {
    let cost:   Int
    let damage: Int
    let armor:  Int
    
    static let emptySlot  = Item(cost:  0, damage: 0, armor: 0)
    
    static let dagger     = Item(cost:  8, damage: 4, armor: 0)
    static let shortsword = Item(cost: 10, damage: 5, armor: 0)
    static let warhammer  = Item(cost: 25, damage: 6, armor: 0)
    static let longsword  = Item(cost: 40, damage: 7, armor: 0)
    static let greataxe   = Item(cost: 74, damage: 8, armor: 0)
    
    static let weapons : [Item] = [dagger, shortsword, warhammer, longsword, greataxe]
    
    static let leather    = Item(cost:  13, damage: 0, armor: 1)
    static let chainmail  = Item(cost:  31, damage: 0, armor: 2)
    static let splintmail = Item(cost:  53, damage: 0, armor: 3)
    static let bandedmail = Item(cost:  75, damage: 0, armor: 4)
    static let platemail  = Item(cost: 102, damage: 0, armor: 5)
    
    static let armors : [Item] = [leather, chainmail, splintmail, bandedmail, platemail]
    
    static let damage1   = Item(cost:  25, damage: 1, armor: 0)
    static let damage2   = Item(cost:  50, damage: 2, armor: 0)
    static let damage3   = Item(cost: 100, damage: 3, armor: 0)
    static let defense1  = Item(cost:  20, damage: 0, armor: 1)
    static let defense2  = Item(cost:  40, damage: 0, armor: 2)
    static let defense3  = Item(cost:  80, damage: 0, armor: 3)
    
    static let rings : [Item] = [damage1, damage2, damage3, defense1, defense2, defense3]
}

struct Player {
    var hit : Int
    var damage : Int
    var armor : Int
}

//Input Data
let boss = Player(hit: 100, damage: 8, armor: 2)

var minCost = Int.max
var maxCost = 0

var armors = Item.armors
armors.insert(.emptySlot, at: 0)

var rings = Item.rings
rings.insert(.emptySlot, at: 0)
rings.insert(.emptySlot, at: 0)

for weapon in Item.weapons {
    for armor in armors {
        for ringIndex1 in 0..<(rings.count-1) {
            let ring1 = rings[ringIndex1]
            for ringIndex2 in (ringIndex1+1)..<rings.count {
                let ring2 = rings[ringIndex2]
                let items = [weapon, armor, ring1, ring2]
                var player = Player(hit: 100, damage: 0, armor: 0)
                var cost = 0
                for item in items {
                    player.damage += item.damage
                    player.armor  += item.armor
                    cost += item.cost
                }
                if isWin(player, boss) {
                    if cost < minCost {
                        minCost = cost
                    }
                } else {
                    if cost > maxCost {
                        maxCost = cost
                    }
                }
            }
        }
    }
}

func isWin(_ player: Player, _ boss: Player) -> Bool {
    var attacker = player
    var defender = boss
    var isPlayer = true
    while attacker.hit > 0 {
        var damage = attacker.damage - defender.armor
        if damage <= 0 {
            damage = 1
        }
        defender.hit -= damage
        
        let tmp = attacker
        attacker = defender
        defender = tmp
        
        isPlayer = !isPlayer
    }
    return !isPlayer
}

print("Day_21_1: \(minCost)")
print("Day_21_2: \(maxCost)")
