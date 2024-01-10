//
//  main.swift
//  Day_11
//
//  Created by Pavlo Liashenko on 11.12.2021.
//

import Foundation

let inputFileURL  = URL(fileURLWithPath: "input.txt")
let inputFileData = try! String(contentsOf: inputFileURL).trimmingCharacters(in: .whitespacesAndNewlines)
var field  = inputFileData.components(separatedBy:.newlines).map{$0.map{Int(String($0))!}}
let width  = field[0].count
let height = field.count
//printField(field)
let steps = 1000
var flashes = 0
for step in 0..<steps {
    field = field.map {
        $0.map {
            $0 + 1
        }
    }
    var flashed : [(x: Int, y: Int)] = []
    repeat {
        flashed = []
        for x in 0..<width {
            for y in 0..<height {
                if field[y][x] > 9 {
                    flashed.append((x: x, y: y))
                    field[y][x] = 0
                    flashes += 1
                }
            }
        }
        
        for (x, y) in flashed {
            for dx in -1...1 {
                for dy in -1...1 {
                    let x = x + dx
                    let y = y + dy
                    if field.indices.contains(y) && field[y].indices.contains(x) && field[y][x] != 0 {
                        field[y][x] += 1
                    }
                }
            }
        }

    } while flashed.count != 0
    
    //print("\n\(step):")
    //printField(field)
    if step == 100-1 {
        print("Day_11_1: \(flashes)")
    }
    
    if field.reduce(0, {$0 + $1.reduce(0){$0 + ($1==0 ? 1:0)}}) == width*height {
        print("Day_11_2: \(step + 1)")
        break
    }

}

func printField(_ field: [[Int]]) {
    print(field.map{$0.map{String(($0 >= 10 ? 0 : $0))}.joined()}.joined(separator:"\r"))
}
