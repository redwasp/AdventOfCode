//
//  main.swift
//  Day_24
//
//  Created by Pavlo Liashenko on 26.01.2023.
//

import Foundation

var data = try! String(contentsOf: URL(fileURLWithPath:"input.txt")).trimmingCharacters(in: .whitespacesAndNewlines)
var groups = Array(data.components(separatedBy:"\n\n").enumerated().map{(team, element) in
    element.components(separatedBy: .newlines).dropFirst().enumerated().map{Group($0.element, $0.offset+1, team)}
}.joined())

struct Group : Hashable {
    enum AttackType: String {
        case cold
        case slashing
        case bludgeoning
        case radiation
        case fire
    }
    var units: Int = 0
    let hp: Int
    var damage: Int
    let attack: AttackType
    let week: Set<AttackType>
    let immune: Set<AttackType>
    let initiative: Int
    let team: Int
    let id: Int
    let key: Int
    
    init(_ str: String, _ id: Int, _ team: Int) {
        var parts = str.components(separatedBy:" with an attack that does ")
        var words = parts[1].components(separatedBy: .whitespaces)
        damage = Int(words[0])!
        attack = AttackType(rawValue:words[1])!
        initiative = Int(words.last!)!
        parts = parts[0].components(separatedBy:" hit points")
        words = parts[0].components(separatedBy: .whitespaces)
        units = Int(words[0])!
        hp = Int(words.last!)!
        var immune: [AttackType] = []
        var week: [AttackType] = []
        for comp in parts[1].trimmingCharacters(in:CharacterSet(charactersIn: " ()")).components(separatedBy:"; ") {
            guard comp.count > 0 else {continue}
            let parts = comp.components(separatedBy:" to ")
            let values = parts[1].components(separatedBy:", ").map{AttackType(rawValue: $0)!}
            if parts[0] == "immune" {
                immune = values
            } else if parts[0] == "weak" {
                week = values
            }
        }
        self.immune = Set(immune)
        self.week = Set(week)
        self.team = team
        self.id = id
        self.key = team * 100 + self.id
    }
    
    var power: Int {
        units * damage
    }
    
    func damage(to group: Group) -> Int {
        guard !group.immune.contains(self.attack) else {return 0}
        guard !group.week.contains(self.attack) else {return power * 2}
        return power
    }
    
    mutating func attack(_ enemy: Group) {
        let damage = enemy.damage(to: self)
        let off = damage/hp
        units -= off
    }
}

extension Group.AttackType : CustomStringConvertible {
    var description: String {
        self.rawValue
    }
}

extension Group : CustomStringConvertible {
    var description: String {
        "ID:\(id) T:\(team) U:\(units) HP:\(hp) D:\(damage) A:\(attack) W:\(week) IM:\(immune) I:\(initiative)"
    }
}

func targets(_ groups: [Group]) -> [Group: Group] {
    var map: [Group: Group]  = [:]
    let groups = groups.sorted {
        if $0.power == $1.power {
            return $0.initiative > $1.initiative
        } else {
            return $0.power > $1.power
        }
    }
    for group in groups {
        var maxDamage = 0
        var maxGroup : Group? = nil
        for enemy in groups {
            guard group.team != enemy.team else {continue}
            guard map[enemy] == nil else {continue}
            let damage = group.damage(to: enemy)
            if damage > maxDamage || (maxGroup != nil && (damage == maxDamage && (enemy.power > maxGroup!.power || (enemy.power == maxGroup!.power && enemy.initiative > maxGroup!.initiative)))) {
                maxDamage = damage
                maxGroup = enemy
            }
        }
        if maxGroup != nil {
            map[maxGroup!] = group
        }
    }
    return map
}
var startGroups = groups.sorted { $0.initiative > $1.initiative}
var boost = 0
repeat {
    groups = startGroups.map{
        var group = $0
        if group.team == 0 {
            group.damage += boost
        }
        return group
    }
    var raund = 0
    var total = 0
    var oldTotal = 1
    while groups.count > 0 && total != oldTotal {
        oldTotal = total
        raund += 1
        let targets = targets(groups)
        guard targets.count > 0 else {break}
        let targets2 = targets.reduce(into:[Int: Int]()) {$0[$1.value.key] = $1.key.key}
        var newGroups : [Int : Group] = groups.reduce(into: [Int : Group]()) {
            $0[$1.key] = $1
        }
        let keys = groups.map{$0.key}
        for key in keys {
            guard let group = newGroups[key] else {continue}
            guard let enemyKey = targets2[key] else {continue}
            guard var enemy = newGroups[enemyKey] else {continue}
            enemy.attack(group)
            if enemy.units > 0 {
                newGroups[enemy.key] = enemy
            } else {
                newGroups[enemy.key] = nil
            }
        }
        groups = newGroups.map{$0.value}.sorted { $0.initiative > $1.initiative}
        total = groups.reduce(into: 0) { $0 += $1.units}
    }
    if boost == 0 {
        let result = groups.reduce(into: 0) { $0 += $1.units}
        print("Day_24_1: \(result)")
    }
    let result = groups.reduce(into: 0) { $0 += $1.units}
    boost += 1
} while groups.contains(where: {$0.team == 1})

let result = groups.reduce(into: 0) { $0 += $1.units}
print("Day_24_2: \(result)")

//
//let Units : [(id:Int, t:Int, u: Int, hp: Int, week:[DamageType], immune:[DamageType], d:Int, dt:DamageType, i:Int)] = [
//    (id: 1, t: 0, u: 554,  hp: 8034,  week: [.Cold], immune: [.Slashing], d: 124, dt: .Bludgeoning, i : 2),
//    (id: 2, t: 0, u: 285,  hp: 3942,  week: [.Cold], immune: [],  d: 107, dt: .Bludgeoning, i :6),
//    (id: 3, t: 0, u: 4470, hp: 7895,  week: [.Radiation], immune:[.Bludgeoning], d : 17 , dt : .Bludgeoning, i : 1),
//    (id: 4, t: 0, u: 4705, hp: 8128,  week: [.Slashing], immune:[], d : 14, dt :  .Bludgeoning, i : 8),
//    (id: 5, t: 0, u: 3788, hp: 7504,  week: [.Cold,.Slashing], immune:[], d : 17, dt :  .Cold, i : 3),
//    (id: 6, t: 0, u: 7087, hp: 2733,  week: [.Bludgeoning], immune:[], d : 3 , dt : .Slashing, i : 14),
//    (id: 7, t: 0, u: 23,   hp: 7234,  week: [], immune: [],  d : 3132 , dt : .Fire, i : 15),
//    (id: 8, t: 0, u: 818,  hp: 7188,  week: [.Fire], immune:[.Radiation, .Slashing], d : 80 , dt : .Fire, i : 19),
//    (id: 9, t: 0, u: 3233, hp: 3713,  week: [.Radiation], immune:[.Cold], d : 10, dt : .Radiation, i : 20),
//    (id: 10, t: 0, u: 1011, hp: 8135,  week: [.Fire], immune:[.Slashing,.Cold,.Bludgeoning], d : 75, dt : .Radiation, i : 12),
//    (id: 1, t: 1, u: 136,  hp: 37513, week: [.Radiation], immune: [], d: 492, dt: .Cold, i:  18),
//    (id: 2, t: 1, u: 4811, hp: 5863,  week: [.Radiation,.Cold], immune:[.Slashing], d: 2, dt: .Radiation, i:  17),
//    (id: 3, t: 1, u: 4057, hp: 9812,  week: [.Slashing], immune: [], d: 4, dt:.Bludgeoning, i:  11),
//    (id: 4, t: 1, u: 2828, hp: 30926, week: [.Cold], immune:[.Bludgeoning], d: 19, dt:.Cold, i:  7),
//    (id: 5, t: 1, u: 2311, hp: 20627, week: [], immune:[.Slashing], d: 17, dt: .Slashing, i:  5),
//    (id: 6, t: 1, u: 1622, hp: 30824, week: [.Slashing, .Bludgeoning], immune:[], d: 34, dt: .Bludgeoning, i:  4),
//    (id: 7, t: 1, u: 108,  hp: 8628,  week: [], immune:[], d: 139, dt: .Slashing, i:  13),
//    (id: 8, t: 1, u: 1256, hp: 51819, week: [], immune:[.Cold,.Slashing], d: 63, dt: .Radiation, i: 16),
//    (id: 9, t: 1, u: 3681, hp: 21469, week: [.Slashing] ,immune:[.Cold, .Bludgeoning], d: 11, dt: .Cold, i: 9),
//    (id: 10, t: 1, u: 7289, hp: 6935,  week: [.Slashing, .Bludgeoning],immune:[], d: 1, dt: .Fire, i: 10)
//]
//
//let Units1 : [(id:Int, t:Int, u: Int, hp: Int, week:[DamageType], immune:[DamageType], d:Int, dt:DamageType, i:Int)] = [
//    (id: 1, t: 0, u: 17,  hp: 5390,  week: [.Radiation, .Bludgeoning], immune: [], d: 4507, dt: .Fire, i : 2),
//(id: 2, t: 0, u: 989,  hp: 1274,  week: [.Bludgeoning, .Slashing], immune: [.Fire], d: 25, dt: .Slashing, i : 3),
//(id: 1, t: 1, u: 801,  hp: 4706,  week: [.Radiation], immune: [], d: 116, dt: .Bludgeoning, i : 1),
//(id: 2, t: 1, u: 4485,  hp: 2961,  week: [.Fire, .Cold], immune: [.Radiation], d: 12, dt: .Slashing, i : 4),
//]
//
//var units = groups[0]
//
//var boost = 0///24
//var end = false
//
//while !end {
////    boost += 1;
////    units = Units
////    for i in 0..<units.count {
////        if (units[i].t == 0) {
////            units[i].d += boost;
////        }
////    }
//    var endTest = false
//    while !endTest {
//        units.sort{if (($0.units*$0.damage) == ($1.units*$1.damage)) {
//                return $0.initiative > $1.initiative
//            } else {
//                return ($0.units*$0.damage) > ($1.units*$1.damage)
//            }
//        }
//       // print("----------")
//        //Target Selection
//        var targets : [(u:Int, e:Int)] = []
//        var used : Set<Int> = []
//
//        for (ui, unit) in units.enumerated() {
//            //print(unit.u*unit.d,unit.i)
//            var maxED = Int.min
//            var maxEID = -1
//            for (ei, enemy) in units.enumerated() {
//                if unit.t != enemy.t && !used.contains(ei) {
//                    var ed = unit.u*unit.d
//                    if enemy.week.contains(unit.dt) {
//                        ed *= 2
//                    }
//                    if enemy.immune.contains(unit.dt) {
//                        ed *= 0
//                        continue;
//                    }
////                    print("Test",(unit.t == 0 ? "Imm" : "Inf"),unit.id,"->",enemy.id, "damage",ed)
//
//                    if (ed > maxED) {
//                        maxED = ed;
//                        maxEID = ei;
//                    } else if ed == maxED {
//                        let enemy1 = units[maxEID]
//                        if enemy.u*enemy.d > enemy1.u*enemy1.d {
//                            maxEID = ei;
//                        } else if enemy.u*enemy.d == enemy1.u*enemy1.d {
//                            if enemy.i > enemy1.i {
//                                maxEID = ei;
//                            }
//                        }
//                    }
//                }
//            }
//            if (maxEID != -1) {
//                used.insert(maxEID);
//                targets.append((u:ui,e:maxEID));
//            }
//        }
//
//        //Attacking
//        var killCount = 0
//        targets.sort{units[$0.u].i > units[$1.u].i}
//        for target in targets {
//            let unit = units[target.u]
//            if unit.u > 0 {
//                var enemy = units[target.e]
//                if enemy.u > 0 {
//                    var ed = unit.u*unit.d
//                    if enemy.week.contains(unit.dt) {
//                        ed *= 2
//                    }
//                    if enemy.immune.contains(unit.dt) {
//                        ed *= 0
//                    }
//                    //let oldU = enemy.u;
//                    enemy.u -= ed/enemy.hp
//                    units[target.e] = enemy
//                    killCount += ed/enemy.hp;
//                    //print("Attack",(unit.t == 0 ? "Imm" : "Inf"),unit.id,"->",enemy.id, "damage",ed,"killing", oldU - (enemy.u > 0 ? enemy.u : 0 ))
//                }
//            }
//        }
//        if (killCount == 0) {
//            print("Boost",boost,"Break");
//            break;
//        }
//        //Fire end
//        var newUnits : [(id:Int, t:Int, u: Int, hp: Int, week:[DamageType], immune:[DamageType], d:Int, dt:DamageType, i:Int)] = []
//        var t0count = 0
//        var t1count = 0
//        for unit in units {
//            if unit.u > 0 {
//                if unit.t == 0 {
//                    t0count += 1;
//                } else {
//                    t1count += 1;
//                }
//                newUnits.append(unit)
//            }
//        }
//        if t0count == 0 || t1count == 0 {
//            endTest = true
//            if (t1count == 0) {
//                end = true
//            }
//        }
//        units = newUnits;
//    }
//    var army = 0
//    for unit in units {
//        army += unit.u
//    }
//    if (boost == 0) {
//        print("Result 1:",army);
//    } else {
//        print("Boost:",boost,"Army:",army);
//    }
//}
//
//print("Boost:",boost);
//
//
//
