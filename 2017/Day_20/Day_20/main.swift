//
//  main.swift
//  Day_20
//
//  Created by Pavlo Liashenko on 28.09.2022.
//

import Foundation

let inputData = try! Data(contentsOf: URL(fileURLWithPath:"input.txt"))
let inputString = String(data:inputData , encoding: .utf8)!
let lines = inputString.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines)
let particles = lines.map{Particle($0)}

struct Particle {
    var p : [Int] //position
    var v : [Int] //velocity
    var a : [Int] //acceleration

    init(_ p: [Int], _ v: [Int], a: [Int]) {
        self.p = p
        self.v = v
        self.a = a
    }
    
    init(_ line: String) {
        let parts = line.components(separatedBy:", ").map{$0.components(separatedBy: "<")}.map{$0[1].dropLast().components(separatedBy:",").map{Int($0.trimmingCharacters(in: .whitespacesAndNewlines))!}}
        p = parts[0]
        v = parts[1]
        a = parts[2]
    }
    mutating func slowMove(to steps: Int = 1) {
        for _ in 0..<steps {
            for i in 0..<p.count {
                v[i] += a[i]
                p[i] += v[i]
            }
        }
    }
    
    func fromMove(to steps: Int = 1) -> Particle {
        var particle = self
        particle.move(to: steps)
        return particle
    }
    
    mutating func move(to steps: Int = 1) {
        for i in 0..<p.count {
            p[i] += v[i]*steps + a[i]*(steps*(steps+1))/2
            v[i] += a[i]*steps
        }
    }
    
    func distanceToZero(to steps: Int = 1) -> Int {
        var distance = 0
        for i in 0..<p.count {
            distance += abs(p[i])
        }
        return distance
    }
}

func distance(_ left: Particle, _ right: Particle) -> Int {
    var distance = 0
    for i in 0..<left.p.count {
        distance += abs(left.p[i] - right.p[i])
    }
    return distance
}

func collide(_ left: Particle, _ right: Particle) -> Int? {
    var d : [Int : Int] = [:]
    var pc = left.p.count
    for i in 0..<left.p.count {
        //(p1-p2) + (v1-v2)*t + (a1-a2)*t(t+1)/2 = 0 * 2
        //(p1-p2) + ((v1-v2)+(a1-a2)/2)*t + ((a1-a2)/2)*t*t = 0
        //
        let a = (left.a[i] - right.a[i])
        let b = (left.v[i] - right.v[i])*2 + a
        let c = (left.p[i] - right.p[i])*2

        if a == 0 {
            if b == 0 {
                if c == 0 {
                    pc -= 1
                } else {
                    return nil
                }
                continue
            } else {
                let x = (-c).quotientAndRemainder(dividingBy:b)
                guard x.remainder == 0 && x.quotient > 0 else {
                    return nil
                }
                d[x.quotient, default: 0] += 1
                continue
            }
        }
        let D = b*b - 4*a*c
        guard D >= 0 else {return nil}
        if D == 0 {
            let x = (-b).quotientAndRemainder(dividingBy: 2*a)
            guard x.remainder == 0 && x.quotient >= 0 else {
                return nil
            }
            d[x.quotient, default: 0] += 1
            continue
        }
        let qD = Int(sqrt(Double(D)))
        guard qD*qD == D else {return nil}
        let x1 = (qD-b).quotientAndRemainder(dividingBy:2*a)
        let x2 = (-qD-b).quotientAndRemainder(dividingBy:2*a)
        if x1.quotient >= 0 && x1.remainder == 0 {
            d[x1.quotient, default: 0] += 1
        }
        if x2.quotient >= 0 && x2.remainder == 0 && x2.quotient != x1.quotient {
            d[x2.quotient, default: 0] += 1
        }
    }

    let df = d.filter{$0.value == pc}
    if df.count == 1 {
        return df.first!.key
    } else {
        return nil
    }
}
//Part 1

let offset = 10_000
var min = Int.max
var minIndex = -1
for index in 0..<particles.count-1 {
    let distance = particles[index].fromMove(to: offset).distanceToZero()
    if distance < min {
        min = distance
        minIndex = index
    }
}
print("Day_20_1: \(minIndex)")

//Part 2
var values : [Int : [(j: Int, i: Int)]] = [:]
for j in 0..<particles.count-1 {
    for i in j+1..<particles.count {
        guard let x = collide(particles[j], particles[i]) else {continue}
        values[x, default:[]].append((j,i))
    }
}

var removed : Set<Int> = []
let steps = values.keys.sorted()
for step in steps {
    var toRemove : Set<Int> = []
    for pair in values[step]! {
        if !removed.contains(pair.i) && !removed.contains(pair.j) {
            toRemove.insert(pair.i)
            toRemove.insert(pair.j)
        }
    }
    removed.formUnion(toRemove)
}




print("Day_20_2: \(particles.count - removed.count)")
