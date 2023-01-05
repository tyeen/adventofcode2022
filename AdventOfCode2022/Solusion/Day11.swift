//
// Created on 2023/01/04, by Yin Tan
// 
//

import Foundation

struct Day11Resolver: Resolver {
    struct ThrowingPolicy {
        let divisor: Int
        let successTarget: Int
        let failureTarget: Int
    }

    struct Monkey {
        let index: Int
        var itemWorryLevels: [Int]
        let increasingWorryLevel: (Int) -> Int
        let throwingPolicy: ThrowingPolicy

        var inspectedItems: Int = 0
    }

    let day = Day(input: "day11")

    func resolve(input: String) {
        let monkeys = parseInput(input)

        resolvePart1(monkeys: monkeys)
        resolvePart2(monkeys: monkeys)
    }

    private func resolvePart1(monkeys: [Monkey]) {
        var monkeys = monkeys
        for _ in 0..<20 {
            for i in 0..<monkeys.count {
                let worryLevels = monkeys[i].itemWorryLevels
                monkeys[i].inspectedItems += worryLevels.count
                monkeys[i].itemWorryLevels.removeAll()
                let throwingPolicy = monkeys[i].throwingPolicy
                for level in worryLevels {
                    let newLevel = monkeys[i].increasingWorryLevel(level) / 3
                    let throwingTargetIndex = newLevel.isMultiple(of: throwingPolicy.divisor)
                    ? throwingPolicy.successTarget : throwingPolicy.failureTarget
                    monkeys[throwingTargetIndex].itemWorryLevels.append(newLevel)
                }
            }
        }
        let itemsCount = monkeys.compactMap { $0.inspectedItems }.sorted { $0 > $1 }
        print("Part1: monkey inspected items count: \(itemsCount)")
        print(itemsCount[0] * itemsCount[1])
    }

    private func resolvePart2(monkeys: [Monkey]) {
        var monkeys = monkeys
        let modulo = monkeys.reduce(1) { partialResult, next in
            partialResult * next.throwingPolicy.divisor
        }
        for _ in 0..<10000 {
            for i in 0..<monkeys.count {
                let worryLevels = monkeys[i].itemWorryLevels
                let throwingPolicy = monkeys[i].throwingPolicy

                monkeys[i].inspectedItems += worryLevels.count
                monkeys[i].itemWorryLevels.removeAll()

                for level in worryLevels {
                    let newLevel = monkeys[i].increasingWorryLevel(level) % modulo
                    let throwingTargetIndex = newLevel.isMultiple(of: throwingPolicy.divisor)
                    ? throwingPolicy.successTarget : throwingPolicy.failureTarget
                    monkeys[throwingTargetIndex].itemWorryLevels.append(newLevel)
                }
            }
        }
        let itemsCount = monkeys.compactMap { $0.inspectedItems }.sorted { $0 > $1 }
        print("Part2: monkey inspected items count: \(itemsCount)")
        print(itemsCount[0] * itemsCount[1])
    }

    private func parseInput(_ input: String) -> [Monkey] {
        input.split(separator: "\n\n").compactMap { (monkeyNote: Substring) -> Monkey? in
            let noteLines = monkeyNote.split(separator: "\n")

            let index = Int(String(noteLines[0].split(separator: " ").last!.dropLast()))!
            let items = (noteLines[1].split(separator: ": ").last!)
                .split(separator: ", ")
                .compactMap { Int($0) }
            // updating rule, hard-code all, tired with the token parsing...
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

            let divisor = Int(String(noteLines[3].split(separator: " ").last!))!
            let succTarget = Int(String(noteLines[4].split(separator: " ").last!))!
            let failureTarget = Int(String(noteLines[5].split(separator: " ").last!))!
            return Monkey(
                index: index,
                itemWorryLevels: items,
                increasingWorryLevel: updating,
                throwingPolicy: ThrowingPolicy(
                    divisor: divisor,
                    successTarget: succTarget,
                    failureTarget: failureTarget))
        }
    }
}
