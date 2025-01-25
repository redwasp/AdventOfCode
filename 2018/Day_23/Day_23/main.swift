//
//  main.swift
//  Day_23
//
//  Created by Pavlo Liashenko on 26.01.2023.
//

import Foundation

print("Start")
print("Load Data")
let data = try! String(contentsOf: URL(fileURLWithPath:"input.txt"))
var id = 0
var lines = data.split(separator: "\n" );
var bots : [(x:Int,y:Int,z:Int,r:Int,id:Int)] = []
for line in lines {
    var comp = line.split(separator: ">")
    var ps = comp[0]
    ps = ps[ps.index(ps.startIndex, offsetBy: 5)..<ps.endIndex]
    var psi = ps.split(separator: ",").map({ (s) -> Int in
        return Int(s)!
    })
    var rs = comp[1]
    rs = rs[rs.index(rs.startIndex, offsetBy: 4)..<rs.endIndex]
    let r = Int(rs)!
    bots.append((x:psi[0], y:psi[1], z:psi[2], r:r, id:id))
    id += 1
}
let iBots = Array(bots)

print("Data Loaded ",bots.count, " Items");

bots.sort { (x1, x2) -> Bool in
    return x1.r > x2.r
}

print("Create Relations");

var r : [Int:Set<Int>] = [:]
var counts : [Int:Int] = [:]

for abot in bots {
    counts[abot.id] = 0
    r[abot.id] = []
    for bbot in bots {
        let d = abs(abot.x - bbot.x) + abs(abot.y - bbot.y) + abs(abot.z - bbot.z)
        if d <= abot.r {
            counts[abot.id] = counts[abot.id]! + 1
        }
        if (abot.id != bbot.id) {
            if d <= abot.r+bbot.r {
                r[abot.id]!.insert(bbot.id)
            }
        }
    }
}

print("Relations Created");

print("Result 1:",counts[bots[0].id]!)

var botsForTest = bots.map({ (s) -> Int in
    return s.id
});

let allItems : Set<Int> = Set.init(0..<bots.count);

var max = 0
var maxGroup : Set<Int> = []


while botsForTest.count != 0  {
    botsForTest.sort { (x1, x2) -> Bool in
        if (r[x1]!.count == r[x2]!.count) {
            return iBots[x1].r > iBots[x2].r
        } else {
            return r[x1]!.count > r[x2]!.count
        }
    }

    let botID = botsForTest[0]
    let bot = iBots[botID]
    var group = Set<Int>([bot.id])
    var relations = r[bot.id]!
    while relations.count != 0 {
        let id = relations.first!
        group.insert(id)
        relations = relations.intersection(r[id]!)
    }

    if (group.count > max) {
        max = group.count
        maxGroup = group
        print("- Current Max Group Count",max);
        var set = Set(botsForTest)
        set = set.subtracting(group);
        botsForTest = Array(set)
    } else {
        var set = Set(botsForTest)
        set = set.subtracting([botID])
        botsForTest = Array(set)
    }
}

print("Real Max Group Count",max);

print("Calc Start point");

var lX = Int.min;
var rX = Int.max;
var lY = Int.min;
var rY = Int.max;
var lZ = Int.min;
var rZ = Int.max;
for id in maxGroup {
    let bot = iBots[id]
    let blx = bot.x - bot.r;
    let brx = bot.x + bot.r;
    if (blx > lX) {
        lX = blx;
    }
    if (brx < rX) {
        rX = brx;
    }
    let bly = bot.y - bot.r;
    let bry = bot.y + bot.r;
    if (bly > lY) {
        lY = bly;
    }
    if (bry < rY) {
        rY = bry;
    }
    let blz = bot.z - bot.r;
    let brz = bot.z + bot.r;
    if (blz > lZ) {
        lZ = blz;
    }
    if (brz < rZ) {
        rZ = brz;
    }
}

var X = (lX+rX)/2;
var Y = (lY+rY)/2;
var Z = (lZ+rZ)/2;

//var maxGroup = [66, 486, 745, 183, 748, 554, 1, 744, 825, 661, 614, 702, 468, 493, 301, 48, 577, 484, 364, 267, 249, 774, 713, 813, 929, 548, 519, 417, 942, 612, 54, 808, 294, 509, 316, 6, 689, 230, 207, 964, 568, 190, 71, 144, 908, 973, 236, 931, 887, 490, 958, 841, 105, 342, 746, 94, 434, 527, 540, 476, 142, 40, 643, 280, 283, 988, 909, 521, 284, 670, 984, 3, 156, 227, 695, 858, 133, 163, 76, 290, 803, 496, 205, 796, 234, 336, 944, 348, 150, 647, 138, 409, 285, 246, 518, 300, 308, 139, 453, 225, 998, 81, 712, 779, 735, 181, 77, 235, 532, 866, 200, 793, 51, 332, 698, 259, 124, 662, 229, 369, 446, 656, 57, 692, 90, 492, 829, 176, 706, 251, 729, 106, 339, 448, 445, 255, 319, 979, 254, 78, 775, 750, 850, 396, 514, 953, 16, 852, 429, 806, 501, 572, 373, 814, 75, 158, 879, 778, 505, 432, 134, 791, 38, 305, 218, 20, 557, 512, 61, 571, 309, 586, 555, 917, 562, 882, 915, 46, 765, 907, 389, 943, 688, 110, 39, 170, 770, 22, 461, 362, 672, 817, 650, 27, 611, 856, 623, 322, 875, 792, 734, 693, 937, 685, 815, 847, 167, 411, 876, 157, 832, 211, 886, 678, 222, 809, 401, 752, 913, 633, 965, 508, 659, 992, 538, 651, 849, 276, 166, 154, 592, 194, 363, 949, 844, 831, 645, 960, 55, 275, 673, 996, 694, 618, 240, 762, 818, 199, 370, 49, 182, 250, 523, 952, 424, 682, 888, 233, 756, 954, 553, 530, 113, 511, 24, 605, 145, 169, 383, 529, 833, 782, 718, 318, 795, 864, 114, 602, 835, 935, 45, 640, 317, 728, 764, 450, 172, 539, 101, 857, 848, 853, 307, 798, 993, 395, 375, 174, 408, 272, 291, 394, 810, 753, 613, 855, 129, 353, 325, 495, 947, 920, 253, 483, 407, 257, 41, 83, 983, 74, 883, 53, 433, 576, 67, 185, 524, 739, 60, 216, 171, 507, 122, 680, 933, 5, 264, 558, 622, 454, 289, 153, 243, 736, 799, 215, 561, 881, 273, 366, 789, 766, 419, 918, 473, 297, 578, 420, 838, 593, 422, 248, 132, 463, 595, 481, 902, 399, 426, 195, 723, 867, 939, 186, 787, 606, 392, 91, 44, 971, 642, 164, 725, 946, 583, 607, 168, 773, 108, 293, 648, 845, 823, 967, 440, 29, 755, 660, 862, 162, 497, 64, 927, 357, 466, 904, 65, 500, 821, 969, 226, 328, 587, 350, 287, 621, 436, 180, 922, 830, 582, 2, 86, 376, 738, 697, 0, 231, 826, 900, 119, 212, 654, 911, 696, 458, 686, 588, 386, 665, 146, 175, 545, 404, 50, 834, 165, 598, 747, 700, 551, 924, 196, 906, 391, 522, 528, 388, 37, 423, 716, 981, 991, 374, 402, 863, 346, 624, 485, 995, 155, 801, 807, 608, 269, 776, 258, 999, 292, 324, 980, 898, 385, 93, 323, 377, 403, 149, 239, 482, 564, 840, 759, 352, 201, 455, 892, 812, 535, 517, 120, 963, 896, 585, 597, 72, 510, 116, 92, 73, 28, 31, 667, 649, 869, 271, 451, 241, 609, 84, 668, 42, 384, 890, 635, 786, 552, 52, 846, 13, 749, 546, 629, 784, 263, 288, 715, 520, 704, 962, 209, 594, 536, 26, 743, 421, 452, 331, 85, 321, 646, 152, 982, 306, 480, 260, 279, 751, 9, 465, 921, 708, 768, 340, 731, 123, 355, 874, 637, 107, 816, 314, 811, 664, 56, 985, 901, 4, 544, 677, 337, 415, 381, 140, 584, 790, 11, 760, 537, 565, 616, 603, 860, 137, 203, 143, 880, 18, 955, 977, 758, 25, 237, 506, 382, 934, 912, 268, 213, 189, 709, 976, 580, 575, 193, 675, 270, 320, 177, 730, 379, 822, 641, 877, 428, 658, 872, 542, 475, 427, 990, 371, 97, 916, 966, 579, 349, 302, 820, 936, 179, 430, 359, 33, 345, 959, 127, 63, 894, 905, 35, 295, 919, 804, 861, 219, 910, 638, 425, 652, 986, 499, 478, 59, 326, 842, 469, 932, 717, 438, 104, 498, 19, 684, 690, 871, 885, 884, 192, 247, 741, 23, 187, 600, 444, 948, 398, 843, 238, 15, 360, 329, 895, 141, 442, 574, 188, 98, 556, 719, 938, 368, 543, 228, 202, 356, 335, 513, 412, 681, 893, 761, 824, 710, 217, 836, 343, 62, 655, 989, 310, 397, 7, 757, 405, 334, 721, 414, 589, 441, 410, 242, 128, 628, 978, 839, 43, 769, 210, 737, 14, 772, 740, 8, 278, 406, 531, 687, 460, 413, 367, 563, 975, 341, 298, 630, 89, 416, 439, 504, 471, 100, 69, 783, 534, 951, 333, 184, 610, 313, 21, 754, 897, 281, 711, 443, 828, 252, 266, 351, 683, 549, 941, 859, 928, 657, 393, 926, 358, 99, 80, 472, 634, 956, 726, 431, 994, 854, 400, 344, 663, 296, 161, 489, 797, 674, 311, 261, 627, 32, 636, 515, 889, 214, 224, 865, 387, 198, 131, 477, 891, 256, 615, 873, 456, 533, 435, 794, 679, 639, 699, 676, 232, 136, 208, 282, 79, 720, 491, 102, 68, 304, 837, 742, 159, 569, 950, 560, 36, 118, 800, 109, 470, 767, 244, 541, 173, 599, 591, 868, 903, 380, 378, 566, 923, 827, 644, 968, 957, 117, 111, 601, 502, 802, 204, 447, 785, 732, 733, 930, 390, 330, 488, 666, 70, 191, 30, 10, 771, 34, 619, 437, 303, 707, 286, 974, 372, 223, 12, 479, 596, 653, 58, 464, 338, 701, 220, 914, 354, 82, 462, 970, 617, 526, 671, 135, 178, 457, 727, 474, 347, 312, 516, 449, 151, 878, 590, 115, 487, 418, 780, 819, 265, 567, 899, 459, 494, 147, 87, 703, 961, 550, 95, 788, 125, 925, 777, 112, 327, 130, 547, 940, 987, 972, 573, 17, 361, 88, 221, 525, 206, 631, 626, 691, 365, 763, 669, 781, 851, 467, 620, 315, 262, 705, 805, 277, 724, 245]
//
//
//let X = 18269310
//let Y = 52043678
//let Z = 60847688

print("Start point",X,Y,Z);

func testPoint(x:Int, y:Int, z:Int) -> (x:Int, y:Int, z:Int, count:Int) {
    var count = 0
    var maxD = Int.min;
    var maxID = 0;

    for id in maxGroup {
        let bot = iBots[id]
        let dx = abs(bot.x - x)
        let dy = abs(bot.y - y)
        let dz = abs(bot.z - z)
        let d = dx + dy + dz
        if d <= bot.r {
            count += 1;
        } else {
            if d - bot.r > maxD {
                maxD = d - bot.r ;
                maxID = bot.id
            }
        }
    }

    if (count != maxGroup.count) {
        let maxBot = iBots[maxID]
        var dd = maxD
        var nX = x
        var nY = y
        var nZ = z

        if (dd > 3) {
            if maxBot.x < x {
                nX -= dd/3;
            } else {
                nX += dd/3;
            }
            dd -= dd/3
            if maxBot.y < y {
                nY -= dd/2;
            } else {
                nY += dd/2;
            }
            dd -= dd/2
            if maxBot.z < z {
                nZ -= dd;
            } else {
                nZ += dd;
            }
        }

        return (nX, nY, nZ, count)

    } else {
        return (x, y, z, count)
    }
}
print("Result 2: ",26794905+46607442+21078787);
 //                  26794905 46607437 21078782
X = 26794905
Y = 46607437
Z = 21078782
max = 0;
for dx in -20...20 {
    for dy in -20...20 {
        for dz in -20...20 {
            var tX = X + dx
            var tY = Y + dy
            var tZ = Z + dz
            let rp = testPoint(x:tX,y:tY,z:tZ);
            if max <= rp.count {
                print("\(rp.count) \(tX) \(tY) \(tZ) \(tX+tY+tZ)")
                max = rp.count
            }
        }
    }
}

//94481134
//
//
//var end = false
//while !end {
//    let rp = testPoint(x:tX,y:tY,z:tZ);
//    end = rp.count == maxGroup.count
//    tX = rp.x;
//    tY = rp.y;
//    tZ = rp.z;
//    print("\(rp.count) x:\(rp.x) y:\(rp.y) z:\(rp.z)");
//}
//print("Best Point",tX,tY,tZ);
//print("Result 2:",tX+tY+tZ);
//print("Result 2: ",26794907+46607440+21078785);
//
//
//
//
//
//
//
