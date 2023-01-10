//
// Created on 2023/01/06, by Yin Tan
// 
//

import Foundation

struct Day12Resolver: Resolver {
    let day = Day(input: "day12")

    private class Node: Equatable, Hashable, CustomStringConvertible {
        let row: Int
        let column: Int
        let elevation: Int
        var distance: Int

        var previous: Node? = nil

        init(row: Int, column: Int, elevation: Int, distance: Int) {
            self.row = row
            self.column = column
            self.elevation = elevation
            self.distance = distance
        }

        static func ==(lhs: Node, rhs: Node) -> Bool {
            lhs.row == rhs.row && lhs.column == rhs.column
        }

        func hash(into hasher: inout Hasher) {
            hasher.combine(row)
            hasher.combine(column)
        }

        var description: String {
            "[elevation: \(elevation), distance: \(distance), at: (\(row), \(column))"
        }
    }

    private struct Puzzle {
        let nodes: [Node]
        let rows: Int
        let columns: Int
        let start: Node
        let end: Node
    }

    func resolve(input: String) {
        let puzzle = parseInput(input)
        resolvePart1(puzzle: puzzle)

        let puzzle2 = parseInput(input)
        resolvePart2(puzzle: puzzle2)
    }

    private func resolvePart1(puzzle: Puzzle) {
        let nodes = puzzle.nodes
        let rows = puzzle.rows
        let columns = puzzle.columns

        let startPosition = puzzle.start
        let endPosition = puzzle.end

        var processingQueue = [startPosition]
        var visitedNodes = Set<Node>()
        var target = startPosition

        while !processingQueue.isEmpty {
            let current = processingQueue.removeFirst()
            if current == endPosition {
                target = current
                break
            }

            visitedNodes.insert(current)

            let top: Node? = current.row > 0
            ? nodes.first(where: { $0.row == current.row - 1 && $0.column == current.column })
            : nil
            let bottom = current.row < rows - 1
            ? nodes.first(where: { $0.row == current.row + 1 && $0.column == current.column })
            : nil
            let left = current.column > 0
            ? nodes.first(where: { $0.row == current.row && $0.column == current.column - 1 })
            : nil
            let right = current.column < columns - 1
            ? nodes.first(where: { $0.row == current.row && $0.column == current.column + 1 })
            : nil

            let candidates = [top, bottom, left, right].compactMap { candidate in
                if let node = candidate, node.elevation <= current.elevation + 1 {
                    return node
                } else {
                    return nil
                }
            }
            for candidate in candidates {
                if let visited = visitedNodes.first(where: { $0 == candidate }),
                    visited.distance <= candidate.distance {
                    continue
                }

                if candidate.distance > current.distance + 1 {
                    candidate.distance = current.distance + 1
                }

                candidate.previous = current
                if let pendingIdx = processingQueue.firstIndex(of: candidate) {
                    processingQueue[pendingIdx] = candidate
                } else {
                    processingQueue.append(candidate)
                }
            }
        }

//        var iterator: Node? = target
//        var steps = ""
//        while let node = iterator, node != startPosition {
//            steps = " -> (\(node.column), \(node.row))" + steps
//
//            iterator = iterator?.previous
//        }
//        steps = "(\(startPosition.row), \(startPosition.column))" + steps
//        print("steps: \(steps)")
        print("Part1: steps: \(target.distance)")
    }

    private func resolvePart2(puzzle: Puzzle) {
        let rows = puzzle.rows
        let columns = puzzle.columns
        let nodes = puzzle.nodes

        let startPosition = puzzle.end
        startPosition.distance = 0
        puzzle.start.distance = .max

        var processingQueue = [startPosition]
        var visitedNodes = Set<Node>()
        var target = startPosition

        while !processingQueue.isEmpty {
            let current = processingQueue.removeFirst()
            if current.elevation == 0 {
                target = current
                break
            }

            visitedNodes.insert(current)

            let top: Node? = current.row > 0
            ? nodes.first(where: { $0.row == current.row - 1 && $0.column == current.column })
            : nil
            let bottom = current.row < rows - 1
            ? nodes.first(where: { $0.row == current.row + 1 && $0.column == current.column })
            : nil
            let left = current.column > 0
            ? nodes.first(where: { $0.row == current.row && $0.column == current.column - 1 })
            : nil
            let right = current.column < columns - 1
            ? nodes.first(where: { $0.row == current.row && $0.column == current.column + 1 })
            : nil

            let candidates = [top, bottom, left, right].compactMap { candidate in
                if let node = candidate, node.elevation >= current.elevation - 1 {
                    return node
                } else {
                    return nil
                }
            }
            for candidate in candidates {
                if let visited = visitedNodes.first(where: { $0 == candidate }),
                    visited.distance <= candidate.distance {
                    continue
                }

                if candidate.distance > current.distance + 1 {
                    candidate.distance = current.distance + 1
                }

                candidate.previous = current
                if let pendingIdx = processingQueue.firstIndex(of: candidate) {
                    processingQueue[pendingIdx] = candidate
                } else {
                    processingQueue.append(candidate)
                }
            }
        }

//        var iterator: Node? = target
//        var steps = ""
//        while let node = iterator, node != startPosition {
//            steps = " -> (\(node.column), \(node.row))" + steps
//
//            iterator = iterator?.previous
//        }
//        steps = "(\(startPosition.row), \(startPosition.column))" + steps
//        print("steps: \(steps)")
        print("Part2: steps: \(target.distance)")
    }

    private func parseInput(_ input: String) -> Puzzle {
        let lines = input.split(separator: "\n")

        let rows = lines.count
        let columns = lines.first!.count
        let indexMap = Dictionary(
            uniqueKeysWithValues: "abcdefghijklmnopqrstuvwxyz".enumerated().map { ($1, $0) }
        )
        var nodes = [Node]()
        var startPosition = Node(row: 0, column: 0, elevation: 0, distance: 0)
        var endPosition = startPosition
        for (row, line) in lines.enumerated() {
            for (column, ch) in line.enumerated() {
                let elevation: Int
                if let index = indexMap[ch] {
                    elevation = index
                } else if ch == "S" {
                    elevation = indexMap["a"]!
                    startPosition = Node(row: row, column: column, elevation: elevation, distance: 0)
                } else if ch == "E" {
                    elevation = indexMap["z"]!
                    endPosition = Node(row: row, column: column, elevation: elevation, distance: .max)
                } else {
                    continue
                }
                let node = Node(row: row, column: column, elevation: elevation, distance: .max)
                nodes.append(node)
            }
        }
        return Puzzle(nodes: nodes, rows: rows, columns: columns, start: startPosition, end: endPosition)
    }
}
