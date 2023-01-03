import Foundation

struct Coordinate: Hashable {
    let row: Int
    let column: Int
}

struct Day8Resolver: Resolver {
    let day = Day(input: "day8")

    func resolve(input: String) {
        let lines = input.split(separator: "\n")

        var map = [[Int]](repeating: [Int](repeating: 0, count: 99), count: 99)
        var rows = 0
        var columns = 0
        for (row, line) in lines.enumerated() {
            guard !line.isEmpty else { continue }
            for (column, heightChar) in line.enumerated() {
                map[row][column] = heightChar.wholeNumberValue!
                if columns < column {
                    columns = column
                }
            }
            rows += 1
        }
        columns += 1 // columns is not the index, but the total count.

        print("Part 1")
        var visiblePoints = Set<Coordinate>()
        var height = -1
        for row in 0..<rows {
            height = -1
            for column in 0..<columns {
                if map[row][column] > height {
                    height = map[row][column]
                    visiblePoints.insert(Coordinate(row: row, column: column))
                }

                if height == 9 {
                    break
                }
            }

            height = -1
            for column in stride(from: columns - 1, to: 0, by: -1) {
                if map[row][column] > height {
                    height = map[row][column]
                    visiblePoints.insert(Coordinate(row: row, column: column))
                }

                if height == 9 {
                    break
                }
            }
        }
        height = -1
        for column in 0..<columns {
            height = -1
            for row in 0..<rows {
                if map[row][column] > height {
                    height = map[row][column]
                    visiblePoints.insert(Coordinate(row: row, column: column))
                }

                if height == 9 {
                    break
                }
            }

            height = -1
            for row in stride(from: rows - 1, to: 0, by: -1) {
                if map[row][column] > height {
                    height = map[row][column]
                    visiblePoints.insert(Coordinate(row: row, column: column))
                }

                if height == 9 {
                    break
                }
            }
        }
        print("Visible trees: \(visiblePoints.count)")

        // Part2
        print("Part 2")
        var scores = [[Int]](repeating: [Int](repeating: 0, count: 99), count: 99)
        for row in 1..<(rows - 1) {
            for column in 1..<(columns - 1) {
                let current = map[row][column]
                var leftScore = 0
                for idx in stride(from: column - 1, through: 0, by: -1) {
                    leftScore += 1
                    if map[row][idx] >= current {
                        break
                    }
                }
                scores[row][column] = leftScore
            }

            for column in stride(from: columns - 2, through: 1, by: -1) {
                let current = map[row][column]
                var rightScore = 0
                for idx in (column + 1)..<columns {
                    rightScore += 1
                    if map[row][idx] >= current {
                        break
                    }
                }
                scores[row][column] *= rightScore
            }
        }

        for column in 1..<(columns - 1) {
            for row in 1..<(rows - 1) {
                let current = map[row][column]
                var topScore = 0
                for idx in stride(from: row - 1, through: 0, by: -1) {
                    topScore += 1
                    if map[idx][column] >= current {
                        break
                    }
                }
                scores[row][column] *= topScore
            }

            for row in stride(from: rows - 2, through: 1, by: -1) {
                let current = map[row][column]
                var bottomScore = 0
                for idx in (row + 1)..<rows {
                    bottomScore += 1
                    if map[idx][column] >= current {
                        break
                    }
                }
                scores[row][column] *= bottomScore
            }
        }

        let highestScore = scores.flatMap { $0 }.max() ?? 0
        print("Part2: \(highestScore)")
    }
}
