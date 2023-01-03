import Foundation

func checkFullContainment(range1: ClosedRange<Int>, range2: ClosedRange<Int>) -> Bool {
    return (range1.lowerBound <= range2.lowerBound && range1.upperBound >= range2.upperBound) ||
    (range2.lowerBound <= range1.lowerBound && range2.upperBound >= range1.upperBound)
}

func checkOverlap(range1: ClosedRange<Int>, range2: ClosedRange<Int>) -> Bool {
    return range1.contains(range2.lowerBound) || range1.contains(range2.upperBound) ||
    range2.contains(range1.lowerBound) || range2.contains(range1.upperBound)
}

struct Day4Resolver: Resolver {
    let day = Day(input: "day4")

    func resolve(input: String) {
        let pairs = input.split(separator: "\n")
        
        var containmentCount = 0 // Part1
        var overlapCount = 0 // Part2
        for pair in pairs {
            let ranges = pair.split(separator: ",")
            guard ranges.count == 2 else { continue }
            let bound1 = ranges[0].split(separator: "-")
            let range1 = Int(bound1[0])!...Int(bound1[1])!
            let bound2 = ranges[1].split(separator: "-")
            let range2 = Int(bound2[0])!...Int(bound2[1])!
            if checkFullContainment(range1: range1, range2: range2) {
                containmentCount += 1
            }
            if checkOverlap(range1: range1, range2: range2) {
                overlapCount += 1
            }
        }
        print("containment(part1): \(containmentCount), overlap(part2): \(overlapCount)")
    }
}
