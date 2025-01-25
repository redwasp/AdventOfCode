//
//  main.swift
//  Day_19
//
//  Created by Pavlo Liashenko on 26.01.2023.
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


var data = try! String(contentsOf: URL(fileURLWithPath:"input.txt"))
var lines = data.split(separator: "\n" )
var ip = Int(lines.removeFirst().components(separatedBy: .whitespaces).last!)!

var functionsNames : [String] =  ["addr","addi","mulr","muli","banr","bani","borr","bori","setr","seti","gtir","gtri","gtrr","eqir","eqri","eqrr"]
let x = functionsNames.firstIndex(of:"banr")
var functions : [([Int],[Int]) -> [Int]] = [addr,addi,mulr,muli,banr,bani,borr,bori,setr,seti,gtir,gtri,gtrr,eqir,eqri,eqrr]
let prog = lines.map { (s) -> [Int] in
    let x = s.split(separator: " ")
    let op = String(x[0])
    let fn = functionsNames.firstIndex(of:op)!
    return [fn, Int(x[1])!, Int(x[2])!, Int(x[3])!];
}
var end = false
var reg = Array.init(repeating: 0, count: 6)
var pointer = 0

while !end {
    pointer = reg[ip]
    let oper = prog[pointer]
    reg = functions[oper[0]](reg,oper)
    if (reg[ip] + 1 >= prog.count) {
        end = true
    } else {
        reg[ip] += 1
    }
}
print("Day_19_1: ",reg[0])

end = false
reg = Array.init(repeating: 0, count: 6)
reg[0] = 1
pointer = 0
//reg = [44, 10551383, 59, 59, 1, 4]
//pointer = 3
while !end {
    pointer = reg[ip]
    let oper = prog[pointer]
    reg = functions[oper[0]](reg,oper)
    if (reg[ip] + 1 >= prog.count) {
        end = true
    } else {
        reg[ip] += 1
    }
    print("\(pointer): \(reg)")

    if pointer == 3 {
        print("\(pointer): \(reg)")
    }
}
let xxx = 43 + 59 + 43 * 59 + 43 * 4159 + 59 * 4159 + 43 * 59 * 4159 + 4159 + 1
print("Day_19_2: \(xxx)")
