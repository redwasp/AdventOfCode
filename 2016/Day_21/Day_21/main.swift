//
//  main.swift
//  Day_21
//
//  Created by Pavlo Liashenko on 01.09.2022.
//

import Foundation

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL)
var lines = inputFileData.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines)

let operations = lines.map{Operation.build($0)!}

var scrambled = "fbgdceah".map{$0}
var rbmap : [Int] = []
for x in 0..<scrambled.count {
    var pos = x
    if pos >= 4 {
        pos += 1
    }
    pos += 1
    if pos >= scrambled.count {
        pos %= scrambled.count
    }
    pos = scrambled.count - pos
    if pos >= scrambled.count {
        pos %= scrambled.count
    }
    let result = scrambled[pos...] + scrambled[..<pos]
    let index = Array(result).firstIndex(of:scrambled[x])
    rbmap.append(index! % scrambled.count)
}

var string = "abcdefgh".map{$0}
for operation in operations {
    let next = operation.perform(string)
    let tmp  = operation.reverse(next)
    if (string != tmp) {
        print("!!! \(String(string)) = \(String(next)) = \(String(tmp)) \(operation)")
    }
    string = next
}
print("Day_21_1: \(String(string))")

for operation in operations.reversed() {
    let next = operation.reverse(scrambled)
    let tmp  = operation.perform(next)
    if (scrambled != tmp) {
        print("!!! \(String(string)) = \(String(next)) = \(String(tmp)) \(operation)")
    }
    scrambled = next
}
print("Day_21_2: \(String(scrambled))")

class Operation {
    
    func perform(_ string: [Character]) -> [Character] {
        string
    }
    
    func reverse(_ string: [Character]) -> [Character] {
        perform(string)
    }
    
    static func build(_ string: String) -> Operation? {
        let parts = string.components(separatedBy: .whitespaces)
        switch (parts[0], parts[1]) {
        case ("swap", "letter"):
            return SwapLetter(parts[2].first!, parts[5].first!)
        case ("swap", "position"):
            return SwapPosition(from: Int(parts[2])!, to: Int(parts[5])!)
        case ("move", "position"):
            return Move(from: Int(parts[2])!, to: Int(parts[5])!)
        case ("rotate", "based"):
            return RotateBased(of: parts[6].first!)
        case ("rotate", let operation):
            return Rotate(operation == "left" ? .left : .right, offset: Int(parts[2])!)
        case ("reverse", "positions"):
            return Reverse(from: Int(parts[2])!, to: Int(parts[4])!)
        default:
            print("Error!!! \(string)")
            break
        }
        return nil
    }
}

class SwapPosition : Operation {
    let from: Int
    let to: Int
    
    init(from: Int, to: Int) {
        self.from = from
        self.to = to
    }
    
    override func perform(_ string: [Character]) -> [Character] {
        var string   = string
        let letter1  = string[from]
        let letter2  = string[to]
        string[from] = letter2
        string[to]  = letter1
        return string
    }
}

class SwapLetter : Operation {
    let letter1 : Character
    let letter2 : Character
    
    init(_ letter1: Character, _ letter2 : Character) {
        self.letter1 = letter1
        self.letter2 = letter2
    }
    
    override func perform(_ string: [Character]) -> [Character] {
        var string = string
        let pos1 = string.firstIndex(of: letter1)!
        let pos2 = string.firstIndex(of: letter2)!
        string[pos1] = letter2
        string[pos2] = letter1
        return string
    }
}

class Move : Operation {
    let from: Int
    let to: Int
    
    init(from: Int, to: Int) {
        self.from = from
        self.to = to
    }
    
    override func perform(_ string: [Character]) -> [Character] {
        var string = string
        let char = string.remove(at: from)
        string.insert(char, at: to)
        return string
    }
    
    override func reverse(_ string: [Character]) -> [Character] {
        var string = string
        let char = string.remove(at: to)
        string.insert(char, at: from)
        return string
    }
}
                                               
class Rotate : Operation {
    enum Orientation {
        case left
        case right
    }
    let orientation : Orientation
    let offset : Int
    
    init(_ orientation: Orientation, offset: Int) {
        self.orientation = orientation
        self.offset = offset
    }
    
    override func perform(_ string: [Character]) -> [Character] {
        var pos = orientation == .left ? offset : string.count - offset
        if pos < 0 {
            pos += string.count
        }
        if pos >= string.count {
            pos %= string.count
        }
        let result = string[pos...] + string[..<pos]
        return Array(result)
    }
    
    override func reverse(_ string: [Character]) -> [Character] {
        var pos = orientation == .right ? offset : string.count - offset
        if pos < 0 {
            pos += string.count
        }
        if pos >= string.count {
            pos %= string.count
        }
        let result = string[pos...] + string[..<pos]
        return Array(result)
    }
}

class RotateBased : Operation {
    let letter : Character
    init(of letter:  Character) {
        self.letter = letter
    }
    
    override func perform(_ string: [Character]) -> [Character] {
        var pos = string.firstIndex(of: letter)!
        if pos >= 4 {
            pos += 1
        }
        pos += 1
        if pos >= string.count {
            pos %= string.count
        }
        pos = string.count - pos
        let result = string[pos...] + string[..<pos]
        return Array(result)
    }
    
    override func reverse(_ string: [Character]) -> [Character] {
        var pos = string.firstIndex(of: letter)!
        pos = rbmap.firstIndex(of: pos)!
        if pos >= 4 {
            pos += 1
        }
        pos += 1
        if pos >= string.count {
            pos %= string.count
        }
        //pos = string.count - pos
        let result = string[pos...] + string[..<pos]
        return Array(result)
    }
}

class Reverse : Operation {
    let from: Int
    let to: Int
    
    init(from: Int, to: Int) {
        self.from = from
        self.to = to
    }
    
    override func perform(_ string: [Character]) -> [Character] {
        var string = string
        let range = from...to
        string.replaceSubrange(range, with: string[range].reversed())
        return string
    }
}
