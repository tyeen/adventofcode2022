import Foundation

struct Day1Resolver : Resolver {
    let day = Day(input: "day1")

    func resolve(input: String) {
        let elves = input.split(separator: "\n\n")

        let calories = elves.map { elf in
            elf.split(separator: "\n").reduce(0) { partialRes, caloryStr in
                Int(caloryStr)! + partialRes
            }
        }
        let descendingOrder = calories.sorted { lhs, rhs in
            lhs > rhs
        }
        let part1Res = descendingOrder[0]
        print("part1: \(part1Res)")
        let part2Res = descendingOrder[0...2].reduce(0) { partialRes, calory in
            partialRes + calory
        }
        print("part2: \(part2Res)")
    }
}
