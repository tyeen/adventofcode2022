import Foundation

struct Day3Resolver: Resolver {
    private let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
    private var priorityMap = [Character: Int](minimumCapacity: 52)

    let day = Day(input: "day3")

    init() {
        for (idx, char) in characters.enumerated() {
            priorityMap[char] = idx
        }
    }

    func resolve(input: String) {
        let items = input.split(separator: "\n")

        // Part1
        let sum = items.reduce(0) { partialResult, item in
            partialResult + (findPriorityPart1(item: String(item)) + 1)
        }
        print("part1: \(sum)")

        // Part2
        var sum2 = 0
        for idx in stride(from: 0, to: items.count, by: 3) {
            sum2 += findPriorityPart2(
                item1: String(items[idx]),
                item2: String(items[idx + 1]),
                item3: String(items[idx + 2])
            ) + 1
        }
        print("part2: \(sum2)")
    }

    private func findPriorityPart1(item: String) -> Int {
        var firstHalfReservation = Array(repeating: 0, count: 52)
        var secondHalfReservation = Array(repeating: 0, count: 52)
        var front = item.startIndex
        var rear = item.index(before: item.endIndex)
        while front < rear {
            var priority = priorityMap[item[front]]!
            if secondHalfReservation[priority] == 1 {
                return priority
            } else if firstHalfReservation[priority] == 0 {
                firstHalfReservation[priority] = 1
            }

            priority = priorityMap[item[rear]]!
            if firstHalfReservation[priority] == 1 {
                return priority
            } else if secondHalfReservation[priority] == 0 {
                secondHalfReservation[priority] = 1
            }

            front = item.index(after: front)
            rear = item.index(before: rear)
        }
        return 0
    }

    private func findPriorityPart2(item1: String, item2: String, item3: String) -> Int {
        var reservation1 = Array(repeating: 0, count: 52)
        var reservation2 = Array(repeating: 0, count: 52)
        var reservation3 = Array(repeating: 0, count: 52)

        let loopEnd = max(item1.count, item2.count, item3.count)
        var index = item1.startIndex
        var priority = 0
        for _ in 0..<loopEnd {
            var nextIndex = index
            if index < item1.endIndex {
                priority = priorityMap[item1[index]]!
                nextIndex = item1.index(after: index)
                if reservation2[priority] == 1 && reservation3[priority] == 1 {
                    return priority
                } else {
                    if reservation1[priority] == 0 {
                        reservation1[priority] = 1
                    }
                }
            }
            if index < item2.endIndex {
                priority = priorityMap[item2[index]]!
                nextIndex = item2.index(after: index)
                if reservation1[priority] == 1 && reservation3[priority] == 1 {
                    return priority
                } else {
                    if reservation2[priority] == 0 {
                        reservation2[priority] = 1
                    }
                }
            }
            if index < item3.endIndex {
                priority = priorityMap[item3[index]]!
                nextIndex = item3.index(after: index)
                if reservation2[priority] == 1 && reservation1[priority] == 1 {
                    return priority
                } else {
                    if reservation3[priority] == 0 {
                        reservation3[priority] = 1
                    }
                }
            }

            index = nextIndex
        }
        return 0
    }
}
