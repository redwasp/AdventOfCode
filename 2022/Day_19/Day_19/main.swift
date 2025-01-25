//
//  main.swift
//  Day_19
//
//  Created by Pavlo Liashenko on 20.12.2022.
//

import Foundation

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL).trimmingCharacters(in: .whitespacesAndNewlines)
var blueprints = inputFileData.components(separatedBy:.newlines).map{Blueprint($0)}

struct Blueprint : CustomStringConvertible {
    let id: UInt8
    let oreOre: UInt8
    let clayOre: UInt8
    let obsidianOre: UInt8
    let obsidianClay: UInt8
    let geodeOre: UInt8
    let geodeObsidian: UInt8
    init (_ str: String) {
        let parts = str.components(separatedBy: ":")
        self.id = UInt8(parts[0].description.components(separatedBy:.whitespaces).last!)!
        let words = parts[1].components(separatedBy:".").map{$0.components(separatedBy:.whitespaces)}
        self.oreOre = UInt8(words[0][5])!
        self.clayOre = UInt8(words[1][5])!
        self.obsidianOre = UInt8(words[2][5])!
        self.obsidianClay = UInt8(words[2][8])!
        self.geodeOre = UInt8(words[3][5])!
        self.geodeObsidian = UInt8(words[3][8])!
    }
    
    var description: String {
        "[\(id)] OO:\(oreOre) CO:\(clayOre) OBO:\(clayOre) OBC:\(obsidianClay) GO:\(geodeOre) GOB:\(geodeObsidian)"
    }
}

struct State: Hashable, CustomStringConvertible {
    var ore: UInt8
    var oreBot: UInt8
    var clay: UInt8
    var clayBot: UInt8
    var obsidian: UInt8
    var obsidianBot: UInt8
    var geodes: UInt8
    var geodesBot: UInt8

    var description: String {
        "\(oreBot)(\(ore)) \(clayBot)(\(clay)) \(obsidianBot)(\(obsidian)) \(geodesBot)(\(geodes))"
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(unsafeBitCast(self, to: Int.self))
    }
    var key: Int {
        unsafeBitCast(self, to: Int.self)
//        Int(bitPattern:self)
//        ore + (oreBot<<8)
//        + (clay<<16) + (clayBot<<24)
//        + (obsidian<<32) + (obsidianBot<<40)
//        + (geodes<<48) + (geodesBot<<56)
    }

}

func findMax2(_ blueprint: Blueprint, steps: Int) -> Int {
    let state = State(ore: 0, oreBot: 1, clay: 0, clayBot: 0, obsidian: 0, obsidianBot: 0, geodes: 0, geodesBot: 0)
    var cache: [[Int: UInt8]] = Array(repeating: [:], count: steps)
    var max: UInt8 = 0
    func find(_ state: State, _ step: Int) -> UInt8 {
        if step == steps {
            if state.geodes > max {
                max = state.geodes
            }
            return state.geodes
        }
        if let value = cache[step][state.key] {
            return value
        }
//        if state.geodesBot == 0 && state.geodes + (steps - step) < max {
//            return 0
//        }
        var newStates: [State] = []
        
        var newState = state
        newState.ore += newState.oreBot
        newState.clay += newState.clayBot
        newState.obsidian += newState.obsidianBot
        newState.geodes += newState.geodesBot

        var skipWait = true
        if state.ore >= blueprint.geodeOre && state.obsidian >= blueprint.geodeObsidian {
            var gState = newState
            gState.ore -= blueprint.geodeOre
            gState.obsidian -= blueprint.geodeObsidian
            gState.geodesBot += 1
            newStates.append(gState)
        } else {
            skipWait = false
        }
        
        if state.ore >= blueprint.obsidianOre && state.clay >= blueprint.obsidianClay {
            var oState = newState
            oState.ore -= blueprint.obsidianOre
            oState.clay -= blueprint.obsidianClay
            oState.obsidianBot += 1
            newStates.append(oState)
        } else {
            skipWait = false
        }
        
        if state.ore >= blueprint.clayOre {
            var cState = newState
            cState.ore -= blueprint.clayOre
            cState.clayBot += 1
            newStates.append(cState)
        } else {
            skipWait = false
        }
        
        if state.ore >= blueprint.oreOre {
            var oState = newState
            oState.ore -= blueprint.oreOre
            oState.oreBot += 1
            newStates.append(oState)
        } else {
            skipWait = false
        }
        if !skipWait {
            newStates.append(newState)
        }
        var max : UInt8 = 0
        for newState in newStates {
            let value = find(newState, step + 1)
            if value > max {
                max = value
            }
        }
        cache[step][state.key] = max
        return max
    }
    max = find(state, 0)
    print("#\(blueprint.id): \(max)")
    return Int(max)
}

func findMax(_ blueprint: Blueprint, steps: UInt8) -> Int {
    var states : Set<State> = [State(ore: 0, oreBot: 1, clay: 0, clayBot: 0, obsidian: 0, obsidianBot: 0, geodes: 0, geodesBot: 0)]
    var newStates : Set<State> = []
    for step in 0..<steps {
        newStates =  []
        for state in states {
            let oldState = state
            var newState = state
            if 255 - newState.ore < newState.oreBot {continue}
            if 255 - newState.clay < newState.clayBot {continue}
            if 255 - newState.obsidian < newState.obsidianBot {continue}
            if 255 - newState.geodes < newState.geodesBot {continue}

            newState.ore += newState.oreBot
            newState.clay += newState.clayBot
            newState.obsidian += newState.obsidianBot
            newState.geodes += newState.geodesBot
            
            var skipWait = true
            if (oldState.ore >= blueprint.geodeOre && oldState.obsidian >= blueprint.geodeObsidian) && (oldState.ore - blueprint.geodeOre < 2*oldState.oreBot-1  || oldState.obsidian - blueprint.geodeObsidian < 2*oldState.obsidianBot-1) {
                var gState = newState
                gState.ore -= blueprint.geodeOre
                gState.obsidian -= blueprint.geodeObsidian
                gState.geodesBot += 1
                newStates.insert(gState)
            } else {
                skipWait = false
            }
            
            if (oldState.ore >= blueprint.obsidianOre && oldState.clay >= blueprint.obsidianClay) && (oldState.ore - blueprint.obsidianOre < 2*oldState.oreBot-1 || oldState.clay - blueprint.obsidianClay < 2*oldState.clayBot-1) {
                var oState = newState
                oState.ore -= blueprint.obsidianOre
                oState.clay -= blueprint.obsidianClay
                oState.obsidianBot += 1
                newStates.insert(oState)
            } else {
                skipWait = false
            }
            
            if oldState.ore >= blueprint.clayOre && oldState.ore - blueprint.clayOre < 2*oldState.oreBot-1 {
                var cState = newState
                cState.ore -= blueprint.clayOre
                cState.clayBot += 1
                newStates.insert(cState)
            } else {
                skipWait = false
            }
            
            if oldState.ore >= blueprint.oreOre && oldState.ore - blueprint.oreOre < 2*oldState.oreBot-1  {
                var oState = newState
                oState.ore -= blueprint.oreOre
                oState.oreBot += 1
                newStates.insert(oState)
            } else {
                skipWait = false
            }
            if !skipWait {
                newStates.insert(newState)
            }
        }
        states = newStates
        
        //TODO: remove this shit
        if step > 20 {
            let set = Set<UInt8>(states.map{$0.geodesBot*(steps-step)+$0.geodes})
            if set.count > 4 {
                let sort = set.sorted().suffix(4)
                let min = sort.first!
                states = states.filter{$0.geodesBot*(steps-step)+$0.geodes >= min}
            }
        }
        
    }
    let max = states.map{$0.geodes}.max()!
    
    //let ss = Set(states.map{$0.geodes}).sorted()
    //print("#\(blueprint.id): \(ss)")
    return Int(max)
}

let result1 = blueprints
             .map {
                 findMax($0, steps: 24)
             }
             .enumerated()
             .reduce(0) {
                 $0 + ($1.offset + 1)*$1.element
             }
print("Day_19_1: \(result1)")//1725

let result2 = blueprints
             .prefix(3)
             .map {
                 findMax($0, steps: 32)
             }
             .enumerated()
             .reduce(1) {
                 $0 * $1.element
             }
print("Day_19_2: \(result2)")//15510
