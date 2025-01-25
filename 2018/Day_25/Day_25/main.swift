//
//  main.swift
//  Day_25
//
//  Created by Pavlo Liashenko on 26.01.2023.
//

import Foundation

let data = try! String(contentsOf: URL(fileURLWithPath:"input.txt"))
let lines = data.split(separator: "\n" )
let d = lines.map { (s) -> [Int] in
    return s.split(separator: ",").map({ (c) -> Int in
        return Int(c)!
    })
}
var r : [[Int]] = []
for p1 in d {
    var rp : [Int] = []
    for (id,p2) in d.enumerated() {
        if p1 != p2 {
            var dis = 0
            for i in 0...3 {
                dis += abs(p1[i]-p2[i])
            }
            if dis <= 3 {
                rp.append(id)
            }
        }
    }
    r.append(rp)
}
var constellation : [[Int]] = []
var rds = Set(0..<r.count)
while rds.count != 0 {
    let rid = rds.popFirst()!
    var toAdd : [Int] = r[rid]
    toAdd.append(rid);
    var p = 0
    while p < toAdd.count {
        let id : Int = toAdd[p]
        rds.remove(id);
        let rp : [Int] = r[id]
        var rs = Set(rp)
        rs.subtract(Set(toAdd))
        toAdd.append(contentsOf: rs)
        p += 1;
    }
    constellation.append(toAdd)
}
print("Day_25_1:",constellation.count);
