//
//  main.swift
//  Day_24
//
//  Created by Pavlo Liashenko on 24.12.2024.
//

import Foundation

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL, encoding: .utf8).trimmingCharacters(in: .whitespacesAndNewlines)
let inputParts = inputFileData.split(separator: "\n\n")
let inputs = inputParts[0].components(separatedBy: .newlines)
    .map{ $0.split(separator: ": ")}
    .reduce(into:[String:Int]()) { $0[String($1[0])] = Int($1[1])}

class Gate {
    var in1: String
    var in2: String
    var out: String
    var oper: String
    
    init(_ in1: String, _ oper: String, _ in2: String, _ out: String) {
        self.in1 = in1
        self.in2 = in2
        self.out = out
        self.oper = oper
    }
    
    func hasInput(_ input: String) -> Bool {
        return input == in1 || input == in2
    }
    
    func hasInputs(_ input1: String, _ input2: String) -> Bool {
        (in1 == input1 && in2 == input2) || (in1 == input2 && in2 == input1)
    }
}

let gates : [Gate] = inputParts[1]
    .components(separatedBy:.newlines)
    .map {
    let parts = $0.split(separator:" -> ")
    let g = parts[0].split(separator:" ")
    return Gate(String(g[0]), String(g[1]), String(g[2]), String(parts[1]))
}

var gatesMap = gates.reduce(into:[String:[Gate]]()) {
    $0[$1.in1, default: []].append($1)
    $0[$1.in2, default: []].append($1)
}
var values = inputs
var focusInputs = Array(inputs.keys)
while focusInputs.count > 0 {
    var nextInputs = Set<String>()
    for input in focusInputs {
        guard let gates = gatesMap[input] else {continue}
        for gate in gates {
            if values[gate.out] == nil,
               let in1 = values[gate.in1],
               let in2 = values[gate.in2]  {
                values[gate.out] = switch gate.oper {
                    case "AND":  in1 & in2
                    case  "OR":  in1 | in2
                    case "XOR":  in1 ^ in2
                    default: 0
                }
                nextInputs.insert(gate.out)
            }
        }
    }
    focusInputs = Array(nextInputs)
}
let z = values.filter{$0.key.first == "z"}.sorted{$0.key > $1.key}.reduce(""){$0+String($1.value)}
print("Day_24_1:", Int(z, radix: 2)!)

guard var ap = gates.first(where: {$0.hasInputs("x00", "y00") && $0.oper == "AND"}) else {exit(0)}
var bp = gates.first{$0.hasInputs("x01", "y01") && $0.oper == "XOR"}!
var xsIp = "x01"
var ysIp = "y01"
var result: Set<String> = []
for zI in 2...44 {
    let sI = String(format:"%02d", zI)
    let xsI = "x" + sI
    let ysI = "y" + sI
    let zsI = "z" + sI

    let b = gates.first{$0.hasInputs(xsI, ysI) && $0.oper == "XOR"}
    let c = gates.first{$0.hasInputs(xsIp, ysIp) && $0.oper == "AND"}
    let d = gates.first{$0.hasInputs(ap.out, bp.out) && $0.oper == "AND"}
    let a = gates.first{$0.hasInputs(c!.out, d!.out) && $0.oper == "OR"}
    if a == nil {
        print("Error A:", zsI)
        continue
    }
    if b == nil {
        print("Error B:", zsI)
        continue
    }
    var z = gates.first{$0.hasInputs(a!.out, b!.out) && $0.oper == "XOR"}
    if z == nil {
        let z1 = gates.first{$0.out == zsI}!
        if z1.in1 == a!.out && z1.in2 != b!.out {
            result.insert(z1.in2)
            result.insert(b!.out)
            let z = gates.first{$0.out == z1.in2}
            (z!.out, b!.out) = (b!.out, z!.out)
        }
        if z1.in2 == a!.out && z1.in1 != b!.out {
            result.insert(z1.in1)
            result.insert(b!.out)
            let z = gates.first{$0.out == z1.in1}
            (z!.out, b!.out) = (b!.out, z!.out)
        }
        if z1.in1 == b!.out && z1.in2 != a!.out {
            result.insert(z1.in2)
            result.insert(a!.out)
            let z = gates.first{$0.out == z1.in2}
            (z!.out, a!.out) = (a!.out, z!.out)
        }
        if z1.in2 == b!.out && z1.in1 != a!.out {
            result.insert(z1.in1)
            result.insert(a!.out)
            let z = gates.first{$0.out == z1.in1}
            (z!.out, a!.out) = (a!.out, z!.out)
        }
        z = z1
    } else if z!.out != zsI {
        let z1 = gates.first{$0.out == zsI}!
        result.insert(z1.out)
        result.insert(z!.out)
        (z!.out, z1.out) = (z1.out, z!.out)
    }
    
    xsIp = xsI
    ysIp = ysI
    ap = a!
    bp = b!
}

print("Day_24_2:", result.sorted().joined(separator: ","))
