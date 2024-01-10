//
//  main.swift
//  Day_19
//
//  Created by Pavlo Liashenko on 19.12.2023.
//

import Foundation

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL).trimmingCharacters(in: .whitespacesAndNewlines)
let comps = inputFileData.components(separatedBy:"\n\n")
let workflows = comps[0].components(separatedBy:.newlines).map{Workflow($0)}.reduce(into: [String: Workflow]()) {$0[$1.name] = $1}
let parts = comps[1].components(separatedBy:.newlines).map{Part($0)}

typealias Part = Dictionary<Character, Int>

extension Part {
    init(_ str: String) {
        self.init()
        let comps = str.trimmingCharacters(in:CharacterSet(charactersIn:"{}"))
           .components(separatedBy:",")
           .map {
               $0.components(separatedBy:"=")
           }
        for comp in comps {
            self[comp[0].first!] = Int(comp[1])!
        }
    }
}

struct Workflow {
    struct Rule {
        enum RuleSign: Character {
            case more = ">"
            case less = "<"
        }
        let attribute: Character
        let sign: RuleSign
        let value: Int
        let completion: String
        
        init(_ str: String) {
            var str = str
            attribute = str.removeFirst()
            sign = RuleSign(rawValue: str.removeFirst())!
            let comps = str.components(separatedBy:":")
            value = Int(comps[0])!
            completion = comps[1]
        }
        
        func split(_ range: ClosedRange<Int>) -> (ClosedRange<Int>, ClosedRange<Int>) {
            if sign == .more {
                if range.upperBound < value {
                    return (0...0, range)
                } else if range.lowerBound > value {
                    return (range,  0...0)
                } else {
                    return ((value+1)...range.upperBound, range.lowerBound...value)
                }
            } else {
                if range.upperBound < value {
                    return (range, 0...0)
                } else if range.lowerBound > value {
                    return (0...0,  range)
                } else {
                    return (range.lowerBound...(value-1), value...range.upperBound)
                }
            }
        }
    }
    let name: String
    let rules: [Rule]
    let completion: String
    
    init(_ str: String) {
        var comps = str.components(separatedBy:"{")
        name = comps[0]
        comps = comps[1].dropLast().components(separatedBy:",")
        completion = comps.removeLast()
        rules = comps.map{Rule($0)}
    }
    
    func process(_ part: Part) -> String {
        for rule in rules {
            let value = part[rule.attribute]!
            if rule.sign == .more && value > rule.value {return rule.completion}
            if rule.sign == .less && value < rule.value {return rule.completion}
        }
        return completion
    }
}

var sum = 0
for part in parts {
    var wName = "in"
    while let workflow = workflows[wName] {
        wName = workflow.process(part)
    }
    if wName == "A" {
        sum += part.reduce(into: 0) { $0 += $1.value}
    }
}
print("Day_19_1: \(sum)")//425811

var accepted: [[Character: ClosedRange<Int>]] = []
func filter(_ wName: String, _ ranges:[Character: ClosedRange<Int>]) {
    guard let workflow = workflows[wName] else {
        if wName == "A" {
            accepted.append(ranges)
        }
        return;
    }
    var ranges = ranges
    for rule in workflow.rules {
        let splits = rule.split(ranges[rule.attribute]!)
        if (splits.0.count > 0) {
            ranges[rule.attribute] = splits.0
            filter(rule.completion, ranges)
        }
        if (splits.1.count > 0) {
            ranges[rule.attribute] = splits.1
        } else {
            return
        }
    }
    filter(workflow.completion, ranges)
}

filter("in", "xmas".reduce(into: [Character: ClosedRange<Int>](), {$0[$1] = 1...4000}))

sum = accepted.reduce(0){$0 + $1.reduce(1){ $0*$1.value.count}}
print("Day_19_2: \(sum)")//131796824371749
