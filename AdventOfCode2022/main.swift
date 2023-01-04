//
// Created on 2023/01/03, by Yin Tan
// 
//

import Foundation

let resolvers: [Resolver] = [
//    Day1Resolver(),
//    Day2Resolver(),
//    Day3Resolver(),
//    Day4Resolver(),
//    Day5Resolver(),
//    Day6Resolver(),
//    Day7Resolver(),
//    Day8Resolver(),
//    Day9Resolver(),
//    Day10Resolver(),
    Day11Resolver()
]

resolvers.forEach {
    $0.printSolution()
    print("")
}
