//
// Created on 2023/01/04, by Yin Tan
// 
//

import Foundation

struct Day10Resolver: Resolver {
    enum Command {
        case addx(op: Int)
        case noop
    }

    let day = Day(input: "day10")

    func resolve(input: String) {
        let commands = input.split(separator: "\n").compactMap { cmdStr -> Command? in
            if cmdStr.starts(with: "addx"),
               let opStr = cmdStr.split(separator: " ").last,
               let op = Int(String(opStr)) {
                return .addx(op: op)
            } else if cmdStr == "noop" {
                return .noop
            } else {
                return nil
            }
        }

        let signalStrength = resolvePart1(commands: commands)
        print("Part1: \(signalStrength)")

        resolvePart2(commands: commands)
    }

    private func resolvePart1(commands: [Command]) -> Int {
        var cycleCounter = 0
        var register = 1
        var signalStrength = 0
        let checkCycles: (Int) -> Void = { cycles in
            switch cycles {
            case 20, 60, 100, 140, 180, 220:
                signalStrength += register * cycles
            default:
                return
            }
        }
        for command in commands {
            switch command {
            case .noop:
                cycleCounter += 1
                checkCycles(cycleCounter)
            case .addx(let op):
                cycleCounter += 1
                checkCycles(cycleCounter)
                cycleCounter += 1
                checkCycles(cycleCounter)
                register += op
            }
        }

        return signalStrength
    }

    private func resolvePart2(commands: [Command]) {
        var crt = [[Character]](repeating: [Character](repeating: ".", count: 40), count: 6)
        let emptySprite = "........................................".map { $0 }
        var sprite = "###.....................................".map { $0 }

        let updateCRT: (Int) -> Void = { cycle in
            let row = (cycle - 1) / 40
            let column = (cycle - 1) % 40
            crt[row][column] = sprite[column] == "#" ? "#" : "."
        }

        var cycles = 0
        var register = 1
        for command in commands {
            switch command {
            case .noop:
                cycles += 1
                updateCRT(cycles)
            case .addx(let op):
                cycles += 1
                updateCRT(cycles)
                cycles += 1
                updateCRT(cycles)
                register += op
                sprite = emptySprite
                let lowerBound = max(0, register - 1)
                let upperBound = min(register + 1, 39)
                if lowerBound <= upperBound {
                    for i in lowerBound...upperBound {
                        sprite[i] = "#"
                    }
                }
            }
        }
        print("Part2: ")
        for row in 0...5 {
            print(String(crt[row]))
        }
    }
}
