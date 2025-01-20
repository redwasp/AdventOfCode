//
//  main.swift
//  Day_4
//
//  Created by Pavlo Liashenko on 20.01.2025.
//

import Foundation

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL, encoding: .utf8).trimmingCharacters(in: .whitespacesAndNewlines)
let nonNumericCharacterSet = CharacterSet(charactersIn:"0123456789").inverted

struct Record: Comparable, CustomStringConvertible {
    static func < (lhs: Record, rhs: Record) -> Bool {
        lhs.timestamp < rhs.timestamp
    }
    
    struct Timestamp: Comparable, CustomStringConvertible {
        let year: Int
        let month: Int
        let day: Int
        
        let hour: Int
        let minute: Int
        
        static func < (lhs: Timestamp, rhs: Timestamp) -> Bool {
            if lhs.year != rhs.year {
                return lhs.year < rhs.year
            }
            if lhs.month != rhs.month {
                return lhs.month < rhs.month
            }
            if lhs.day != rhs.day {
                return lhs.day < rhs.day
            }
            if lhs.hour != rhs.hour {
                return lhs.hour < rhs.hour
            }
            return lhs.minute < rhs.minute
        }
        
        init(_ string: String) {
            let parts = string.components(separatedBy: nonNumericCharacterSet).map{Int($0)!}
            year = parts[0]
            month = parts[1]
            day = parts[2]
            hour = parts[3]
            minute = parts[4]
        }

        var description: String {
            return "\(year)-\(month)-\(day) \(hour):\(minute)"
        }
    }
    enum Command: CustomStringConvertible, Equatable {
        case fallsAsleep
        case wakesUp
        case guardBeginsShift(Int)
        init (_ string: String) {
            switch string {
            case let s where s.hasPrefix("Guard #"):
                var idString = s.dropFirst("Guard #".count)
                idString = idString[..<idString.firstIndex(of:" ")!]
                let id = Int(String(idString))!
                self = .guardBeginsShift(id)
            case "falls asleep":
                self = .fallsAsleep
            case "wakes up":
                self = .wakesUp
            default : fatalError("Unknown command: \(string)")
            }
        }
        
        var description: String {
            switch self {
            case .guardBeginsShift(let id): return "Guard #\(id) begins shift"
            case .fallsAsleep: return "falls asleep"
            case .wakesUp: return "wakes up"
            }
        }
    }
    let timestamp: Timestamp
    let command: Record.Command
    
    init(_ string: String) {
        let parts = string.split(separator:"] ")
        self.timestamp = Timestamp(String(parts[0].dropFirst()))
        self.command = .init(String(parts[1]))
    }
    
    var description: String {
        return "[\(timestamp)] \(command)\n"
    }
}

let records = inputFileData.components(separatedBy: .newlines).map{Record($0)}.sorted()

var times : [Int:[Int]] = [:]
var sleep : [Int:Int] = [:]
let emptyHour = Array.init(repeating: 0, count: 60)
var currentID = 0
var (startSleep, endSleep) = (0, 0)

var maxMinNumber = 0
var maxMinCount = 0
var maxMinId = 0
var maxSleep  = 0
var maxSleepId  = 0

for record in records {
    switch record.command {
    case .guardBeginsShift(let id):
        currentID = id
        if times[id] == nil {
            times[id] = emptyHour
        }
        if sleep[id] == nil {
            sleep[id] = 0
        }
    case .fallsAsleep:
        startSleep = record.timestamp.minute
    case .wakesUp:
        endSleep = record.timestamp.minute
        let duration = endSleep - startSleep
        sleep[currentID]! += duration
        
        if (sleep[currentID]! > maxSleep) {
            maxSleep = sleep[currentID]!
            maxSleepId = currentID;
        }

        for i in startSleep..<endSleep {
            let value = times[currentID]![i] + 1
            times[currentID]![i] = value
            if maxMinCount < value {
                maxMinCount = value
                maxMinNumber = i
                maxMinId = currentID
            }
        }
    }
}

var maxX = 0
var maxID = 0

for i in 0..<times[maxSleepId]!.count {
    if (times[maxSleepId]![i] > maxX) {
        maxX = times[maxSleepId]![i]
        maxID = i;
    }
}

print("Day_4_1:", maxSleepId * maxID)

print("Day_4_2:", maxMinId * maxMinNumber)


