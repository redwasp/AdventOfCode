//
//  main.swift
//  Day_20
//
//  Created by Pavlo Liashenko on 10.06.2022.
//

import Foundation

let input = 36000000
var min = input/10

let n = 25
var A = Array(repeating: true, count: n)
for i in 2..<n {
    if A[i] {
        var j = i + i
        while j < n {
            A[j] = false
            j += i
        }
    }
}
var primes = A.enumerated().compactMap{$0.element ? $0.offset : nil}
primes.removeFirst()
primes.removeFirst()

var minIndex = Int.max
var minSum = Int.max

func find(_ sum: Int, _ offset: Int, _ index: Int, _ set: Set<Int>) {
    for i in offset..<primes.count {
        let prime = primes[i]
        let newIndex = index*prime
        if newIndex > minIndex {return}
        var newSum = sum
        var newSet = set
        for element in set {
            let item = element * prime
            if !set.contains(item) {
                newSum += item
                newSet.insert(item)
            }
        }
        if newSum < min {
            find(newSum, i, newIndex, newSet)
        } else {
            minIndex = newIndex
            minSum = newSum
            //print("- \(minIndex) \(minSum)")
        }
    }
}

find(1, 0, 1, [1])
print("Day_20_1: \(minIndex)")
//print("Calc:\(calc(minIndex))")

func calc(_ n: Int) -> Int {
    var sum = 0
    for i in 1...n {
        if n % i == 0 {
            sum += i
        }
    }
    return sum
}


min = input/11
minIndex = Int.max
minSum = Int.max

func find2(_ sum: Int, _ offset: Int, _ index: Int, _ set: Set<Int>) {
    for i in offset..<primes.count {
        let prime = primes[i]
        let newIndex = index*prime
        if newIndex > minIndex {return}
        var newSet = set
        for element in set {
            let item = element * prime
            if !set.contains(item) {
                newSet.insert(item)
            }
        }
        let res = newIndex.quotientAndRemainder(dividingBy: 50)
        let minSize = res.remainder == 0 ? res.quotient : res.quotient + 1
        let newSum = newSet.reduce(into: 0) {if $1 >= minSize {$0 += $1}}

        if newSum < min {
            find2(newSum, i, newIndex, newSet)
        } else {
            minIndex = newIndex
            minSum = newSum
        }
    }
}

find2(1, 0, 1, [1])
print("Day_20_2: \(minIndex)")

func calc2(_ n: Int) -> Int {
    var sum = 0
    let res = n.quotientAndRemainder(dividingBy: 50)
    let minN = res.remainder == 0 ? res.quotient : res.quotient + 1
    for i in minN...n {
        if n % i == 0 {
            sum += i
        }
    }
    return sum
}
