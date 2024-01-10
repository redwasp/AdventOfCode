//
//  main.swift
//  Day_22
//
//  Created by Pavlo Liashenko on 30.05.2022.
//

import Foundation

struct Boss {
    var hp     = 71
    var damage = 10
}

struct Wizard {
    var hp    = 50
    var mana  = 500
    var armor = 0
}

struct Effect {
    enum Kind: CaseIterable {
        case MagicMissile
        case Drain
        case Shield
        case Poison
        case Recharge
    }
    
    var kind: Kind
    var cost: Int
    var length: Int
    var action: (_ wizard: inout Wizard, _ boss: inout Boss) -> Void
    
    init(_ kind: Kind) {
        self.kind   = kind
        switch kind {
        case .MagicMissile:
            self.cost = 53
            self.length = 1
            self.action = {
                $0.hp += 0
                $1.hp -= 4
            }
        case .Drain:
            self.cost = 73
            self.length = 1
            self.action = {
                $0.hp += 2
                $1.hp -= 2
            }
        case .Shield:
            self.cost = 113
            self.length = 6
            self.action = {
                $0.armor = 7
                $1.hp += 0
            }
        case .Poison:
            self.cost = 173
            self.length = 6
            self.action = {
                $0.hp += 0
                $1.hp -= 3
            }
        case .Recharge:
            self.cost = 229
            self.length = 5
            self.action = {
                $0.mana += 101
                $1.hp += 0
            }
        }
    }
    
    func process(_ wizard: inout Wizard, _ boss: inout Boss) -> Effect?  {
        var effect = self
        effect.length -= 1
        effect.action(&wizard, &boss)
        return  effect.length > 0 ? effect : nil
    }
}

var effects: [Effect] = []
var minMana = Int.max

func find(_ isPlayer: Bool, _ boss: Boss, _ wizard: Wizard, _ effects: [Effect], _ mana: Int) {
    guard mana < minMana else {return}

    var wizard = wizard
    wizard.armor = 0

    var boss = boss
    let effects = effects.compactMap{$0.process(&wizard, &boss)}
    if boss.hp <= 0 {
        if mana <= minMana {
            minMana = mana
        }
        return
    }
    
    if isPlayer {

        let kinds : Set<Effect.Kind> = Set(effects.map{$0.kind})

        for kind in Effect.Kind.allCases {
            guard !kinds.contains(kind) else {continue}
            var wizard = wizard
            let effect = Effect(kind)
            guard wizard.mana >= effect.cost else {continue}
            wizard.mana -= effect.cost
            var effects = effects
            effects.append(effect)
            let mana = mana + effect.cost
            find(false, boss, wizard, effects, mana)
        }

    } else {
        var damage = boss.damage - wizard.armor
        
        if damage < 1 {
            damage = 1
        }
        wizard.hp -= damage
        guard wizard.hp > 0 else {return}
        find(true, boss, wizard, effects, mana)
    }
}

let boss = Boss()
let wizard = Wizard()
//wizard.hp += boss.damage

find(true, boss, wizard, [], 0)
print("Day_22_1:\(minMana)");

func find2(_ isPlayer: Bool, _ boss: Boss, _ wizard: Wizard, _ effects: [Effect], _ mana: Int) {
    guard mana < minMana else {return}

    var wizard = wizard
    wizard.armor = 0
    
    var boss = boss
    let effects = effects.compactMap{$0.process(&wizard, &boss)}
    if boss.hp <= 0 {
        if mana <= minMana {
            minMana = mana
        }
        return
    }
    
    if isPlayer {
        wizard.hp -= 1

        let kinds : Set<Effect.Kind> = Set(effects.map{$0.kind})

        for kind in Effect.Kind.allCases {
            guard !kinds.contains(kind) else {continue}
            var wizard = wizard
            let effect = Effect(kind)
            guard wizard.mana >= effect.cost else {continue}
            wizard.mana -= effect.cost
            var effects = effects
            effects.append(effect)
            let mana = mana + effect.cost
            find2(false, boss, wizard, effects, mana)
        }

    } else {
        var damage = boss.damage - wizard.armor
        
        if damage < 1 {
            damage = 1
        }
        wizard.hp -= damage
        guard wizard.hp > 0 else {return}
        find2(true, boss, wizard, effects, mana)
    }
}


minMana = Int.max
find2(true, Boss(), Wizard(), [], 0)
print("Day_22_2:\(minMana)");
