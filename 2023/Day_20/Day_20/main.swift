//
//  main.swift
//  Day_20
//
//  Created by Pavlo Liashenko on 20.12.2023.
//

import Foundation

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL).trimmingCharacters(in: .whitespacesAndNewlines)
var modules = inputFileData.components(separatedBy:.newlines).map{module($0)}
var map: [String: Module] = [:]

class Module {
    var name: String
    var connections: [String]
    init(name: String, connections: [String]) {
        self.name = name
        self.connections = connections
    }
    
    func send(_ pulse: Bool, from: String) -> [(from: String, to: String, pulse: Bool)] {
        []
    }
}

class FlipFlop: Module {
    var state: Bool = false
    override func send(_ pulse: Bool, from: String) -> [(from: String, to: String, pulse: Bool)] {
        guard !pulse else {return []}
        state = !state
        return connections.map{(name, $0, state)}
    }
}

class Conjunction: Module {
    var states: [String: Bool] = [:]
    override func send(_ pulse: Bool, from: String) -> [(from: String, to: String, pulse: Bool)] {
        states[from] = pulse
        var pulse = true
        for (_, value) in states {
            if !value {
                pulse = false
                break;
            }
        }
        return connections.map{(name, $0, !pulse)}
    }
}

class Broadcaster: Module {
    override func send(_ pulse: Bool, from: String) -> [(from: String, to: String, pulse: Bool)] {
        connections.map{(name, $0, pulse)}
    }
}

func module(_ str: String) -> Module {
    let comps = str.components(separatedBy:" -> ")
    let connections = comps[1].components(separatedBy:", ")
    if comps[0].hasPrefix("%") {
        return FlipFlop(name: String(comps[0].dropFirst()), connections: connections)
    } else if comps[0].hasPrefix("&") {
        return Conjunction(name: String(comps[0].dropFirst()), connections: connections)
    } else {
        return Broadcaster(name: comps[0], connections: connections)
    }
}

for module in modules {
    map[module.name] = module
    if let conjunction = module as? Conjunction {
        for module in modules {
            if module.connections.contains(conjunction.name) {
                conjunction.states[module.name] = false
            }
        }
    }
}

let relations = findRelations(findRelations("rx").first!)
func findRelations(_ target: String) -> Set<String> {
    var relations: Set<String> = []
    for (name, module) in map {
        if module.connections.contains(target) {
            relations.insert(name)
        }
    }
    return relations
}

var steps: [String: [Int]] = [:]
for module in relations {
    steps[module] = []
}

var low = 0
var height = 0
var result1 = 0
var exit = false
var step = 0
while !exit {
    step += 1
    var l = 0
    var h = 0
    var pulses = [(from: "button", to: "broadcaster", pulse: false)]
    while pulses.count != 0 {
        l += pulses.reduce(0) { $0 + ($1.pulse ? 1 : 0)}
        h += pulses.reduce(0) { $0 + ($1.pulse ? 0 : 1)}
        var newPulses: [(from: String, to: String, pulse: Bool)] = []
        for pulse in pulses {
            if relations.contains(pulse.from) && pulse.pulse == true {
                steps[pulse.from]!.append(step)
                if steps.first(where: { $0.value.count < 2}) == nil {
                    exit = true
                }
            }
            guard let module = map[pulse.to] else {continue}
            newPulses.append(contentsOf: module.send(pulse.pulse, from: pulse.from))
        }
        pulses = newPulses
    }
    low += l
    height += h
    if (step == 1000) {
        result1 = low*height
        print("Day_20_1: \(result1)")
    }
}

let result2 = steps.reduce(1) {$0 * ($1.value[1]-$1.value[0])}
print("Day_20_2: \(result2)")//238815727638557
