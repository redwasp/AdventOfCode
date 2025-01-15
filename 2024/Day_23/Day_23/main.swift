//
//  main.swift
//  Day_23
//
//  Created by Pavlo Liashenko on 23.12.2024.
//

import Foundation

let inputFileURL  = URL(fileURLWithPath: "input1.txt")
let inputFileData = try! String(contentsOf: inputFileURL, encoding: .utf8).trimmingCharacters(in: .whitespacesAndNewlines)
var connections = inputFileData.components(separatedBy:.newlines)
    .map{$0.components(separatedBy:"-")}
    .reduce(into:[String:Set<String>]()) {
    $0[$1[0], default: []].insert($1[1])
    $0[$1[1], default: []].insert($1[0])
}
print(connections.reduce(into:[String:Int](), { $0[$1.key, default:0] = $1.value.count}))
var set : Set<Set<String>> = []
for (a, setA)in connections {
    guard a.first == "t" else {continue}
    for b in setA {
        let setB = connections[b]!
        for c in setB {
            guard c != a && c != b else {continue}
            let setC = connections[c]!
            guard setC.contains(a) else {continue}
            let s: Set<String> = [a,b,c]
            guard !set.contains(s) else {continue}
            set.insert(s)
            print(a, b, c)
        }
    }
}
print("Day_23_1:", set.count)

var max: Set<String> = []
func clique(_ C: Set<String>, _ P: Set<String>) {
    if C.count > max.count {
        max = C
    }
    guard C.count + P.count > max.count else {return}
    var Px = P
    for p in P.sorted() {
        Px.remove(p)
        var Cn = C
        Cn.insert(p)
        let Pn = Px.intersection(connections[p]!)
        clique(Cn, Pn)
    }
}

clique([],Set(connections.keys))
print("Day_23_2:", max.sorted().joined(separator:","))
