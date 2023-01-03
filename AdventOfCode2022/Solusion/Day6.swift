import Foundation

struct Buffer {
    private var buffer = [Character]()
    private var enqueued = 0
    private let nonduplicatingCount: Int

    init(nonduplicatingCount: Int) {
        self.nonduplicatingCount = nonduplicatingCount
    }

    var totalEnqueuedCharacters: Int {
        enqueued
    }

    func generateAlphabetMap() -> [Character: Int] {
        let alphabet = "abcdefghijklmnopqrstuvwxyz"
        return Dictionary(uniqueKeysWithValues: alphabet.map { ($0, 0) })
    }

    /// - returns: `true` for there are duplicates after the enqueuing, else `false`
    mutating func enqueue(char: Character) -> Bool {
        enqueued += 1
        if buffer.count >= nonduplicatingCount {
            buffer.removeFirst()
        }
        buffer.append(char)
        if buffer.count == nonduplicatingCount {
            var alphabetMap = generateAlphabetMap()
            for item in buffer {
                if alphabetMap[item] == 0 {
                    alphabetMap[item] = 1
                } else {
                    return true
                }
            }
            print("duplicated buffer: \(buffer)")
            return false
        } else {
            return true
        }
    }
}

struct Day6Resolver: Resolver {
    let day = Day(input: "day6")

    func resolve(input: String) {
        let content = input

        // Part1
        print("Part1: ")
        var buffer = Buffer(nonduplicatingCount: 4)
        for ch in content {
            if !buffer.enqueue(char: ch) {
                print(buffer.totalEnqueuedCharacters)
                break
            }
        }
        // Part2
        print("Part2: ")
        var buffer2 = Buffer(nonduplicatingCount: 14)
        for ch in content {
            if !buffer2.enqueue(char: ch) {
                print(buffer2.totalEnqueuedCharacters)
                break
            }
        }
    }
}
