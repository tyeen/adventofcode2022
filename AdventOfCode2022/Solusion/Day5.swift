import Foundation

struct Crate {
    let name: String
}

// The following data is determined according to the input data.
struct CrateBoard {
    static let stackCount = 9
    static let maxCrateCount = 56
    var board: [[Crate?]]
    var stackTopPointers: [Int]

    init() {
        // Input Data:
        //             [G] [W]         [Q]
        // [Z]         [Q] [M]     [J] [F]
        // [V]         [V] [S] [F] [N] [R]
        // [T]         [F] [C] [H] [F] [W] [P]
        // [B] [L]     [L] [J] [C] [V] [D] [V]
        // [J] [V] [F] [N] [T] [T] [C] [Z] [W]
        // [G] [R] [Q] [H] [Q] [W] [Z] [G] [B]
        // [R] [J] [S] [Z] [R] [S] [D] [L] [J]
        //  1   2   3   4   5   6   7   8   9
        board = [[Crate?]](
            repeating: [Crate?](repeating: nil, count: CrateBoard.maxCrateCount),
            count: CrateBoard.stackCount
        )
        stackTopPointers = [Int](repeating: 0, count: CrateBoard.stackCount)
        let stack1 = [
            Crate(name: "R"),
            Crate(name: "G"),
            Crate(name: "J"),
            Crate(name: "B"),
            Crate(name: "T"),
            Crate(name: "V"),
            Crate(name: "Z")
        ]
        let stack2 = [
            Crate(name: "J"),
            Crate(name: "R"),
            Crate(name: "V"),
            Crate(name: "L")
        ]
        let stack3 = [
            Crate(name: "S"),
            Crate(name: "Q"),
            Crate(name: "F")
        ]
        let stack4 = [
            Crate(name: "Z"),
            Crate(name: "H"),
            Crate(name: "N"),
            Crate(name: "L"),
            Crate(name: "F"),
            Crate(name: "V"),
            Crate(name: "Q"),
            Crate(name: "G")
        ]
        let stack5 = [
            Crate(name: "R"),
            Crate(name: "Q"),
            Crate(name: "T"),
            Crate(name: "J"),
            Crate(name: "C"),
            Crate(name: "S"),
            Crate(name: "M"),
            Crate(name: "W")
        ]
        let stack6 = [
            Crate(name: "S"),
            Crate(name: "W"),
            Crate(name: "T"),
            Crate(name: "C"),
            Crate(name: "H"),
            Crate(name: "F")
        ]
        let stack7 = [
            Crate(name: "D"),
            Crate(name: "Z"),
            Crate(name: "C"),
            Crate(name: "V"),
            Crate(name: "F"),
            Crate(name: "N"),
            Crate(name: "J")
        ]
        let stack8 = [
            Crate(name: "L"),
            Crate(name: "G"),
            Crate(name: "Z"),
            Crate(name: "D"),
            Crate(name: "W"),
            Crate(name: "R"),
            Crate(name: "F"),
            Crate(name: "Q")
        ]
        let stack9 = [
            Crate(name: "J"),
            Crate(name: "B"),
            Crate(name: "W"),
            Crate(name: "V"),
            Crate(name: "P")
        ]
        for (idx, crate) in stack1.enumerated() {
            board[0][idx] = crate
        }
        stackTopPointers[0] = stack1.count - 1
        for (idx, crate) in stack2.enumerated() {
            board[1][idx] = crate
        }
        stackTopPointers[1] = stack2.count - 1
        for (idx, crate) in stack3.enumerated() {
            board[2][idx] = crate
        }
        stackTopPointers[2] = stack3.count - 1
        for (idx, crate) in stack4.enumerated() {
            board[3][idx] = crate
        }
        stackTopPointers[3] = stack4.count - 1
        for (idx, crate) in stack5.enumerated() {
            board[4][idx] = crate
        }
        stackTopPointers[4] = stack5.count - 1
        for (idx, crate) in stack6.enumerated() {
            board[5][idx] = crate
        }
        stackTopPointers[5] = stack6.count - 1
        for (idx, crate) in stack7.enumerated() {
            board[6][idx] = crate
        }
        stackTopPointers[6] = stack7.count - 1
        for (idx, crate) in stack8.enumerated() {
            board[7][idx] = crate
        }
        stackTopPointers[7] = stack8.count - 1
        for (idx, crate) in stack9.enumerated() {
            board[8][idx] = crate
        }
        stackTopPointers[8] = stack9.count - 1
    }

    mutating func moveSingle(from: Int, to: Int, count: Int) {
        for _ in 0..<count {
            let crate = board[from][stackTopPointers[from]]
            board[to][stackTopPointers[to] + 1] = crate
            board[from][stackTopPointers[from]] = nil
            stackTopPointers[from] -= 1
            stackTopPointers[to] += 1
        }
    }

    mutating func moveBlock(from: Int, to: Int, count: Int) {
        let fromRange = (stackTopPointers[from] - count + 1)...stackTopPointers[from]
        var toStackTopIndex = stackTopPointers[to] + 1
        for fromStackIndex in fromRange {
            let crate = board[from][fromStackIndex]
            board[to][toStackTopIndex] = crate
            board[from][fromStackIndex] = nil
            toStackTopIndex += 1
        }
        stackTopPointers[from] -= count
        stackTopPointers[to] += count
    }

    func topCrates() -> [Crate] {
        var ret = [Crate]()
        for i in 0..<CrateBoard.stackCount {
            let index = stackTopPointers[i]
            if let caret = board[i][index] {
                ret.append(caret)
            } else {
                ret.append(Crate(name: ""))
            }
        }
        return ret
    }
}

struct Command {
    let steps: Int
    let from: Int
    let to: Int
}

private func parseCommand(command: String) -> Command {
    let parts = command.split(separator: " ")
    let steps = Int(parts[1])!
    let from = Int(parts[3])! - 1
    let to = Int(parts[5])! - 1
    return Command(steps: steps, from: from, to: to)
}

struct Day5Resolver: Resolver {
    let day = Day(input: "day5")

    func resolve(input: String) {
        let lines = input.split(separator: "\n")
        let firstCommandIdx = lines.firstIndex { line in
            line.starts(with: "move")
        } ?? 0
        let commands = lines[firstCommandIdx..<lines.count]

        // Part1
        var part1Board = CrateBoard()
        for commandLine in commands {
            let command = parseCommand(command: String(commandLine))
            part1Board.moveSingle(from: command.from, to: command.to, count: command.steps)
        }
        let part1Res = part1Board.topCrates().map { $0.name }.joined()
        print("part1: \(part1Res)")

        // Part2
        var part2Board2 = CrateBoard()
        for commandLine in commands {
            let command = parseCommand(command: String(commandLine))
            part2Board2.moveBlock(from: command.from, to: command.to, count: command.steps)
        }
        let part2Res = part2Board2.topCrates().map { $0.name }.joined()
        print("part2: \(part2Res)")
    }
}
