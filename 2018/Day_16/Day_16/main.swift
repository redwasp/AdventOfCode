//
//  main.swift
//  Day_16
//
//  Created by Pavlo Liashenko on 22.01.2023.
//

import Foundation

//addr (add register) stores into register C the result of adding register A and register B.

func addr(data:[Int], operand:[Int]) -> [Int] {
    var res = data
    res[operand[3]] = res[operand[1]] + res[operand[2]]
    return res
}

//addi (add immediate) stores into register C the result of adding register A and value B.

func addi(data:[Int], operand:[Int]) -> [Int] {
    var res = data
    res[operand[3]] = res[operand[1]] + operand[2]
    return res
}

//mulr (multiply register) stores into register C the result of multiplying register A and register B.

func mulr(data:[Int], operand:[Int]) -> [Int] {
    var res = data
    res[operand[3]] = res[operand[1]] * res[operand[2]]
    return res
}

//muli (multiply immediate) stores into register C the result of multiplying register A and value B.

func muli(data:[Int], operand:[Int]) -> [Int] {
    var res = data
    res[operand[3]] = res[operand[1]] * operand[2]
    return res
}

//banr (bitwise AND register) stores into register C the result of the bitwise AND of register A and register B.

func banr(data:[Int], operand:[Int]) -> [Int] {
    var res = data
    res[operand[3]] = res[operand[1]] & res[operand[2]]
    return res
}

//bani (bitwise AND immediate) stores into register C the result of the bitwise AND of register A and value B.

func bani(data:[Int], operand:[Int]) -> [Int] {
    var res = data
    res[operand[3]] = res[operand[1]] & operand[2]
    return res
}

//borr (bitwise OR register) stores into register C the result of the bitwise OR of register A and register B.

func borr(data:[Int], operand:[Int]) -> [Int] {
    var res = data
    res[operand[3]] = res[operand[1]] | res[operand[2]]
    return res
}

//bori (bitwise OR immediate) stores into register C the result of the bitwise OR of register A and value B.
func bori(data:[Int], operand:[Int]) -> [Int] {
    var res = data
    res[operand[3]] = res[operand[1]] | operand[2]
    return res
}

//setr (set register) copies the contents of register A into register C. (Input B is ignored.)
func setr(data:[Int], operand:[Int]) -> [Int] {
    var res = data
    res[operand[3]] = res[operand[1]]
    return res
}

//seti (set immediate) stores value A into register C. (Input B is ignored.)
func seti(data:[Int], operand:[Int]) -> [Int] {
    var res = data
    res[operand[3]] = operand[1]
    return res
}

//gtir (greater-than immediate/register) sets register C to 1 if value A is greater than register B. Otherwise, register C is set to 0.
func gtir(data:[Int], operand:[Int]) -> [Int] {
    var res = data
    res[operand[3]] = operand[1] > res[operand[2]] ? 1 : 0
    return res
}

//gtri (greater-than register/immediate) sets register C to 1 if register A is greater than value B. Otherwise, register C is set to 0.
func gtri(data:[Int], operand:[Int]) -> [Int] {
    var res = data
    res[operand[3]] = res[operand[1]] > operand[2] ? 1 : 0
    return res
}

//gtrr (greater-than register/register) sets register C to 1 if register A is greater than register B. Otherwise, register C is set to 0.
func gtrr(data:[Int], operand:[Int]) -> [Int] {
    var res = data
    res[operand[3]] = res[operand[1]] > res[operand[2]] ? 1 : 0
    return res
}

//eqir (equal immediate/register) sets register C to 1 if value A is equal to register B. Otherwise, register C is set to 0.
func eqir(data:[Int], operand:[Int]) -> [Int] {
    var res = data
    res[operand[3]] = operand[1] == res[operand[2]] ? 1 : 0
    return res
}

//eqri (equal register/immediate) sets register C to 1 if register A is equal to value B. Otherwise, register C is set to 0.
func eqri(data:[Int], operand:[Int]) -> [Int] {
    var res = data
    res[operand[3]] = res[operand[1]] == operand[2] ? 1 : 0
    return res
}

//eqrr (equal register/register) sets register C to 1 if register A is equal to register B. Otherwise, register C is set to 0.
func eqrr(data:[Int], operand:[Int]) -> [Int] {
    var res = data
    res[operand[3]] = res[operand[1]] == res[operand[2]] ? 1 : 0
    return res
}


let data = try! String(contentsOf: URL(fileURLWithPath:"input.txt")).trimmingCharacters(in: .whitespacesAndNewlines)
let parts = data.components(separatedBy:"\n\n\n")
let lines = parts[0].split(separator: "\n" )
var tests : [[[Int]]] = []
for index in 0..<lines.count/3 {
    var before = lines[index*3]
    before = before[before.index(before.startIndex, offsetBy: 9)..<before.index(before:before.endIndex)]
    let beforeArr = before.split(separator: ",").map { (str) -> Int in
        return Int(str.trimmingCharacters(in: .whitespaces))!
    }
    let operandArr = lines[index*3+1].split(separator: " ").map { (str) -> Int in
        return Int(str)!
    }
    var after = lines[index*3+2]
    after = after[after.index(after.startIndex, offsetBy: 9)..<after.index(before:after.endIndex)]
    let afterArr = after.split(separator: ",").map { (str) -> Int in
        return Int(str.trimmingCharacters(in: .whitespaces))!
    }
    var item : [[Int]] = []
    item.append(beforeArr)
    item.append(operandArr)
    item.append(afterArr)
    tests.append(item)
}
var count = 0
var functions : [([Int],[Int]) -> [Int]] = [addr,addi,mulr,muli,banr,bani,borr,bori,setr,seti,gtir,gtri,gtrr,eqir,eqri,eqrr]

var eq : [Set<Int>] = Array.init(repeating: Set<Int>.init(0...15), count: 16)
let baseSet = Set<Int>.init(0...15)

for item in tests {
    var tcount = 0
    var tSet = baseSet
    for (index, fn) in functions.enumerated() {
        let res = fn(item[0],item[1])
        if res == item[2] {
            tcount += 1
            tSet.remove(index)
        }
    }
    let fi = item[1][0]
    eq[fi].subtract(tSet)
    if tcount >= 3 {
        count += 1
    }
}

print("Day_16_1: \(count)")

var fr = Set<Int>.init()
while fr.count != eq.count {
    for i in 0...15 {
        if (!fr.contains(i) && eq[i].count == 1) {
            fr.insert(i)
            let eqi = eq[i].first!
            for j in 0...15 {
                if !fr.contains(j) {
                    eq[j].remove(eqi)
                }
            }
        }
    }
}

var fmap = eq.map { (set) -> Int in
    return set.first!
}

let lines2 = parts[1].split(separator: "\n" )
let prog = lines2.map { (line) -> [Int] in
    return line.split(separator: " ").map { (str) -> Int in
        return Int(str)!
    }
}
var reg = [0, 0, 0, 0]
for oper in prog {
    reg = functions[fmap[oper[0]]](reg,oper)
}
print("Day_16_2: \(reg[0])")


