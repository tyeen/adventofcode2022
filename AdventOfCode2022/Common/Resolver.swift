//
// Created on 2023/01/03, by Yin Tan
// 
//

import Foundation

protocol Resolver {
    var day: Day { get }

    func resolve(input: String)
}

extension Resolver {
    func printSolution() {
        print("--- \(day.input) -----")
        guard let contents = InputReader.read(day: day), !contents.isEmpty else {
            print("Can't read inputs of \(day.input)")
            return
        }
        resolve(input: contents)
        print("--------------")
    }
}
