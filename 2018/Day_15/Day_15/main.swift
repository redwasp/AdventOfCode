//
//  main.swift
//  Day_15
//
//  Created by Pavlo Liashenko on 22.01.2023.
//

import Foundation

import Foundation

let data = try! String(contentsOf: URL(fileURLWithPath:"input.txt"))
let lines = data.components(separatedBy: .newlines)
let nX = [0, -1, 1, 0]
let nY = [-1, 0, 0, 1]
var field : [[Int]] = []
var units : [[Int]] = []
var eCount = 0
var gCount = 0
var fullPoints = 0
var ePower = 3
var gPower = 3

for line in lines {
    var fieldRow : [Int] = []
    var unitsRow : [Int] = []
    for char in line {
        switch char {
        case "#":
            fieldRow.append(1)
            unitsRow.append(0)
            break
        case ".":
            fieldRow.append(0)
            unitsRow.append(0)
            break
        case "G":
            gCount += 1
            fieldRow.append(0)
            unitsRow.append(200)
            fullPoints += 200
            break
        case "E":
            eCount += 1
            fieldRow.append(0)
            unitsRow.append(-200)
            fullPoints += 200
            break
        default:
            break
        }
    }
    field.append(fieldRow)
    units.append(unitsRow)
}

func distance(x : Int , y : Int, signum : Int) -> (completed : Bool, x : Int,  y : Int) {
    var used : Set<Int> = []
    var levels : [[(x:Int,y:Int, step:Int)]] = []
    var newNext : [(x:Int,y:Int, step:Int)] = []
    newNext.append((x : x, y: y, step : 0))

    var end = false
    var step = 0
    while !end {
        let next = newNext
        newNext = []
        step += 1;
        for point in next {
            for i in 0...3 {
                var yy = point.y + nY[i]
                var xx = point.x + nX[i]
                //print("+++",yy,xx)
                let xy = yy * units.count + xx
                if used.contains(xy) {
                    //print("Skip",yy,xx,"Repeat")
                    continue
                }
                used.insert(xy)
                if units[yy][xx] != 0 && units[yy][xx].signum() != signum {
                    //print("G", xx, yy)
                    end = true;
                    for level in levels.reversed() {
                        for item in level {
                            if (abs(item.x - xx)+abs(item.y - yy) == 1) {
                                xx = item.x
                                yy = item.y
                                continue;
                            }
                        }
                    }
                    //print("Gmin", xx, yy)
                    return (true, xx, yy)
                } else {
                    if (units[yy][xx] == 0 && field[yy][xx] == 0) {
                        newNext.append((x : xx, y: yy, step:step))
                    } else {
                        //print("Skip",yy,xx,"Beasy")
                    }
                }
            }
        }
        if (newNext.count == 0) {
            return (false, 0, 0)
        }
        newNext.sort {p1 , p2 in
            if p1.y == p2.y {
                return p1.x < p2.x
            } else {
                return p1.y < p2.y
            }
        }
        levels.append(newNext)
    }
}

func bestEnemy(x : Int, y:Int, signum : Int) -> (find:Bool, x : Int, y : Int) {
    let enemySignum = -signum
    var enemyX = -1
    var enemyY = -1
    var minS = Int.max
    for i in 0...3 {
        let yy = y + nY[i]
        let xx = x + nX[i]
        if units[yy][xx] != 0 && units[yy][xx].signum() == enemySignum && abs(units[yy][xx]) < minS {
            enemyX = xx
            enemyY = yy
            minS = abs(units[yy][xx])
        }
    }
    return (minS != Int.max, enemyX, enemyY)
}

var end = false
var round = 0
var theEnd = false

func attack(x : Int, y:Int) {
    //atack
    let enemySignum = units[y][x].signum()
    let pow = enemySignum == -1 ? gPower : ePower;
    if (abs(units[y][x]) < pow) {
        fullPoints -= abs(units[y][x])
        units[y][x] = 0
    } else {
        fullPoints -= pow
        units[y][x] -= pow*enemySignum
    }

    if units[y][x] == 0 {
        if (enemySignum == -1) {
            eCount -= 1
            end = true
            print("Destroy Elf");
            return
        } else {
            gCount -= 1
            print("Destroy Goblin");
        }
        if eCount == 0 || gCount == 0 {
            print("Day_15_2:\((round-1)*fullPoints)")
            theEnd = true
        }
    }
}

let fieldInit = field
let unitsInit = units
let eCountInit = eCount
let gCountInit = gCount
let fullPointsInit = fullPoints
while !theEnd {
    
field = fieldInit
units = unitsInit
eCount = eCountInit
gCount = gCountInit
fullPoints = fullPointsInit
end = false
round = 0
ePower += 1

print("+X+++",ePower,"+++X+");

    while !end {
    round += 1
    //print("-",round,"-")
    var skip : Set<Int> = []
    for y in 0..<units.count {
        for x in 0..<units[y].count {
            if (skip.contains(y*units.count+x)) {
                continue
            }
            let unit = units[y][x];
            if unit != 0 {
                let unitSignum = unit.signum()
                let enemy = bestEnemy(x: x, y: y, signum: unitSignum)
                if (enemy.find) {
                    attack(x: enemy.x, y: enemy.y)
                } else {
                    
                    let mv = distance(x : x, y : y, signum : unitSignum)
                    if mv.completed {
                        //print("Move:",y,x," -> ",mv.y,mv.x)
                        units[y][x] = 0
                        units[mv.y][mv.x] = unit
                        skip.insert(mv.y*units.count + mv.x)
                        let enemy = bestEnemy(x: mv.x, y: mv.y, signum:unitSignum)
                        if (enemy.find) {
                            attack(x: enemy.x, y: enemy.y)
                        }
                    } else {
                        //print("Stop:", y,x)
                    }
                }
            }
        }
    }
    if ePower == 3 {
        print("-",round,"-")
    }
    //print("-",units,"-")

}
    
}


