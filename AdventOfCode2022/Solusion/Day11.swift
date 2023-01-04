//
// Created on 2023/01/04, by Yin Tan
// 
//

import Foundation

struct Day11Resolver: Resolver {
    struct ThrowingPolicy {
        let condition: (Int) -> Bool
        let successTarget: Int
        let failureTarget: Int
    }

    struct Monkey {
        let index: Int
        var items: [Int]
        let updating: (Int) -> Int
        let throwingPolicy: ThrowingPolicy
    }

    let day = Day(input: "day11")

    func resolve(input: String) {
        let monkeys = parseInput(input)
        var rounds = 0
        for monkey in monkeys {
            
        }
        print(monkeys)
    }

    private func parseInput(_ input: String) -> [Monkey] {
        input.split(separator: "\n\n").compactMap { (monkeyNote: Substring) -> Monkey? in
            let noteLines = monkeyNote.split(separator: "\n")

            let index = Int(String(noteLines[0].split(separator: " ").last!.dropLast()))!
            let items = (noteLines[1].split(separator: ": ").last!)
                .split(separator: ", ")
                .compactMap { Int($0) }
            // updating rule
            let rawUpdatingRule = String(noteLines[2].split(separator: ": ").last!)
            let updatingRuleParts = rawUpdatingRule.split(separator: " ")
            let op = String(updatingRuleParts[3])
            let operand = String(updatingRuleParts.last!)
            let updating: (Int) -> Int
            switch op {
            case "+":
                if let number = Int(operand) {
                    updating = { x in x + number }
                } else if operand == "old" {
                    updating = { x in x + x }
                } else {
                    return nil
                }
            case "*":
                if let number = Int(operand) {
                    updating = { x in x * number }
                } else if operand == "old" {
                    updating = { x in x * x }
                } else {
                    return nil
                }
            default:
                return nil
            }

            let divNumber = Int(String(noteLines[3].split(separator: " ").last!))!
            let succTarget = Int(String(noteLines[4].split(separator: " ").last!))!
            let failureTarget = Int(String(noteLines[5].split(separator: " ").last!))!
            return Monkey(
                index: index,
                items: items,
                updating: updating,
                throwingPolicy: ThrowingPolicy(
                    condition: { $0 % divNumber == 0 },
                    successTarget: succTarget,
                    failureTarget: failureTarget))
        }
    }
}
