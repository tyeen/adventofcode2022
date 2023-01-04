//
// Created on 2023/01/04, by Yin Tan
// 
//

import Foundation

struct Motion {
    enum Direction {
        case right, left, up, down

        init?(stringValue: String) {
            switch stringValue.lowercased() {
            case "r": self = .right
            case "l": self = .left
            case "u": self = .up
            case "d": self = .down
            default: return nil
            }
        }
    }

    let direction: Direction
    let steps: Int
}

struct Position: Hashable {
    var x: Int
    var y: Int

    func isAround(_ another: Position) -> Bool {
        abs(x - another.x) <= 1 && abs(y - another.y) <= 1
    }
}

struct Day9Resolver: Resolver {
    let day = Day(input: "day9")

    func resolve(input: String) {
        let motions = input.split(separator: "\n").compactMap { motionStr -> Motion? in
            let parts = motionStr.split(separator: " ")
            guard parts.count == 2,
                  let direction = Motion.Direction(stringValue: String(parts[0])),
                  let steps = Int(parts[1])
            else {
                return nil
            }
            return Motion(direction: direction, steps: steps)
        }

        let visitied = recordRopeTailVisitedPositions(motions: motions, knots: 2)
        print("Part1: tail visited \(visitied.count) positions")

        let visitied2 = recordRopeTailVisitedPositions(motions: motions, knots: 10)
        print("Part2: tail visited \(visitied2.count) positions")
    }

    private func recordRopeTailVisitedPositions(motions: [Motion], knots: Int) -> Set<Position> {
        var knots = [Position](repeating: Position(x: 0, y: 0), count: knots)
        let knotsCount = knots.count
        var visited: Set<Position> = [knots.last!]
        for motion in motions {
            switch motion.direction {
            case .left:
                for _ in 1...motion.steps {
                    knots[0].x -= 1
                    var moved = false
                    for i in 1..<knotsCount {
                        if !knots[i].isAround(knots[i - 1]) {
                            if knots[i].x > knots[i - 1].x {
                                knots[i].x -= 1
                            } else if knots[i].x < knots[i - 1].x {
                                knots[i].x += 1
                            }
                            if knots[i].y > knots[i - 1].y {
                                knots[i].y -= 1
                            } else if knots[i].y < knots[i - 1].y {
                                knots[i].y += 1
                            }
                            if i == knotsCount - 1 {
                                visited.insert(knots[i])
                            }
                            moved = true
                        }
                        if !moved {
                            break
                        }
                    }
                }
            case .right:
                for _ in 1...motion.steps {
                    knots[0].x += 1
                    var moved = false
                    for i in 1..<knotsCount {
                        if !knots[i].isAround(knots[i - 1]) {
                            if knots[i].x < knots[i - 1].x {
                                knots[i].x += 1
                            } else if knots[i].x > knots[i - 1].x {
                                knots[i].x -= 1
                            }
                            if knots[i].y > knots[i - 1].y {
                                knots[i].y -= 1
                            } else if knots[i].y < knots[i - 1].y {
                                knots[i].y += 1
                            }
                            if i == knotsCount - 1 {
                                visited.insert(knots[i])
                            }
                            moved = true
                        }
                        if !moved {
                            break
                        }
                    }
                }
            case .up:
                for _ in 1...motion.steps {
                    knots[0].y += 1
                    var moved = false
                    for i in 1..<knotsCount {
                        if !knots[i].isAround(knots[i - 1]) {
                            if knots[i].y < knots[i - 1].y {
                                knots[i].y += 1
                            } else if knots[i].y > knots[i - 1].y {
                                knots[i].y -= 1
                            }
                            if knots[i].x > knots[i - 1].x {
                                knots[i].x -= 1
                            } else if knots[i].x < knots[i - 1].x {
                                knots[i].x += 1
                            }
                            if i == knotsCount - 1 {
                                visited.insert(knots[i])
                            }
                            moved = true
                        }
                        if !moved {
                            break
                        }
                    }
                }
            case .down:
                for _ in 1...motion.steps {
                    knots[0].y -= 1
                    var moved = false
                    for i in 1..<knotsCount {
                        if !knots[i].isAround(knots[i - 1]) {
                            if knots[i].y > knots[i - 1].y {
                                knots[i].y -= 1
                            } else if knots[i].y < knots[i - 1].y {
                                knots[i].y += 1
                            }
                            if knots[i].x > knots[i - 1].x {
                                knots[i].x -= 1
                            } else if knots[i].x < knots[i - 1].x {
                                knots[i].x += 1
                            }
                            if i == knotsCount - 1 {
                                visited.insert(knots[i])
                            }
                            moved = true
                        }
                        if !moved {
                            break
                        }
                    }
                }
            }
        }

        return visited
    }
}
