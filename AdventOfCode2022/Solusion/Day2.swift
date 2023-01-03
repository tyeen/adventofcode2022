import Foundation

private enum Choice: Int {
    case rock = 1
    case paper = 2
    case scissors = 3

    init?(fromString: String) {
        switch fromString {
        case "A", "X": self = .rock
        case "B", "Y": self = .paper
        case "C", "Z": self = .scissors
        default: return nil
        }
    }
}

private enum RoundResult: Int {
    case lose = 0
    case draw = 3
    case win = 6

    init?(fromString: String) {
        switch fromString {
        case "X": self = .lose
        case "Y": self = .draw
        case "Z": self = .win
        default: return nil
        }
    }
}

private func checkResult(opponent: Choice, me: Choice) -> RoundResult {
    switch (opponent, me) {
    case (.rock, .rock), (.paper, .paper), (.scissors, .scissors): return .draw
    case (.paper, .scissors), (.rock, .paper), (.scissors, .rock): return .win
    default: return .lose
    }
}

private func determinChoice(opponent: Choice, result: RoundResult) -> Choice {
    switch result {
    case .draw: return opponent
    case .lose:
        switch opponent {
        case .rock: return .scissors
        case .paper: return .rock
        case .scissors: return .paper
        }
    case .win:
        switch opponent {
        case .rock: return .paper
        case .paper: return .scissors
        case .scissors: return .rock
        }
    }
}

struct Day2Resolver: Resolver {
    let day = Day(input: "day2")

    func resolve(input: String) {
        let rounds = input.split(separator: "\n")

        // Part1
        var part1Result = 0
        for round in rounds {
            let choices = round.split(separator: " ")
            if let opponent = Choice(fromString: String(choices[0])),
               let me = Choice(fromString: String(choices[1])) {
                part1Result += checkResult(opponent: opponent, me: me).rawValue + me.rawValue
            }
        }
        print("part1: \(part1Result)")

        // Part2
        var part2Result = 0
        for round in rounds {
            let strategy = round.split(separator: " ")
            if let opponent = Choice(fromString: String(strategy[0])),
               let result = RoundResult(fromString: String(strategy[1])) {
                let myChoice = determinChoice(opponent: opponent, result: result)
                part2Result += result.rawValue + myChoice.rawValue
            }
        }
        print("part2: \(part2Result)")
    }
}
