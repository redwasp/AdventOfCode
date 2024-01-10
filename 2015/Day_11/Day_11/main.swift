//
//  main.swift
//  Day_11
//
//  Created by Pavlo Liashenko on 08.06.2022.
//

import Foundation

let input = "hepxcrrq"

var map : [Character : Character] = [:]
for i in 97..<122 {
    map[Character(UnicodeScalar(i)!)] = Character(UnicodeScalar(i+1)!)
}
map["z"] = "a"

func next(_ password: String) -> String {
    var password = password
    var index = password.endIndex
    repeat {
        index = password.index(before: index)
        password.replaceSubrange(index...index, with: [map[password[index]]!])
    } while password[index] == "a" && index != password.startIndex
    return password
}

func hasBadSymbols(_ password: String) -> Bool {
    let badSymbols : Set<Character> = ["o","i","l"]
    for char in password {
        if badSymbols.contains(char) {
            return true
        }
    }
    return false
}

func hasPairs(_ password: String) -> Bool {
    var index = password.startIndex
    var nextIndex = password.index(after: index)
    var set : Set<Character> = []
    while nextIndex < password.endIndex {
        if password[index] == password[nextIndex] {
            set.insert(password[index])
        }
        index = nextIndex
        nextIndex = password.index(after: index)
    }
    return set.count >= 2
}

func hasTriplets(_ password: String) -> Bool {
    var index1 = password.startIndex
    var index2 = password.index(after: index1)
    var index3 = password.index(after: index2)
    while index3 < password.endIndex {
        if map[password[index1]] == password[index2] &&
           map[password[index2]] == password[index3] &&
            password[index1] != "z" && password[index2] != "z" {
            return true
        }
        index1 = index2
        index2 = index3
        index3 = password.index(after: index3)
    }
    return false
}

func find(_ password: String) -> String {
    var valid : Bool = false
    var nextPassword = password
    while !valid {
        nextPassword = next(nextPassword)
        guard !hasBadSymbols(nextPassword),
              hasPairs(nextPassword),
              hasTriplets(nextPassword) else {continue}
        valid = true
    }
    return nextPassword
}

var password = find(input)
print("Day_11_1: \(password)")

var password2 = find(password)
print("Day_11_2: \(password2)")

