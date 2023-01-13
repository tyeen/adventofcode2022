//
// Created on 2023/01/12, by Yin Tan
// 
//

import Foundation

struct Day13Resolver: Resolver {
    private enum Packet: CustomStringConvertible {
        indirect case sequence([Packet])
        case element(Int)

        var description: String {
            switch self {
            case .sequence(let packets):
                return "[\(packets.compactMap { $0.description }.joined(separator: ", "))]"
            case .element(let num):
                return "\(num)"
            }
        }
    }

    private struct PacketPair {
        let left: Packet
        let right: Packet
    }

    let day = Day(input: "day13")

    func resolve(input: String) {
        let pairs = parseInput(input)

        resolvePart1(pairs: pairs)
    }

    private func resolvePart1(pairs: [PacketPair]) {
        var rightOrders = [(PacketPair, Int)]()
        for (idx, pair) in pairs.enumerated() {
            switch comparePacket(left: pair.left, right: pair.right) {
            case .isEqual:
                continue
            case .isInRightOrder(let isRightOrder):
                if isRightOrder {
                    rightOrders.append((pair, idx + 1))
                }
            }
        }
        var sum = 0
        rightOrders.forEach { rightOrderItem in
            print("pair \(rightOrderItem.1): \(rightOrderItem.0)")
            sum += rightOrderItem.1
        }
        print("Part 1: \(sum)")
    }

    private enum ComparisionResult {
        case isInRightOrder(Bool)
        case isEqual
    }

    private func comparePacket(left: Packet, right: Packet) -> ComparisionResult {
        let res: ComparisionResult
        switch (left, right) {
        case (.sequence(let sequenceLeft), .sequence(let sequenceRight)):
            res = compareSequences(left: sequenceLeft, right: sequenceRight)
        case (.element(let elementLeft), .element(let elementRight)):
            if elementLeft == elementRight {
                print("  \(elementLeft) == \(elementRight), continue")
                res = .isEqual
            } else {
                print("  return result of \(elementLeft) < \(elementRight)\n")
                res = .isInRightOrder(elementLeft < elementRight)
            }
        case (.element(let elementLeft), .sequence(let sequenceRight)):
            let leftPromoted = [Packet.element(elementLeft)]
            res = compareSequences(left: leftPromoted, right: sequenceRight)
        case (.sequence(let sequenceLeft), .element(let elementRight)):
            let rightPromoted = [Packet.element(elementRight)]
            res = compareSequences(left: sequenceLeft, right: rightPromoted)
        }
        return res
    }

    private func compareSequences(left: [Packet], right: [Packet]) -> ComparisionResult {
        print("compare seq: \(left), \(right)")
        if left.isEmpty && !right.isEmpty {
            print("  left is empty, right order\n")
            return .isInRightOrder(true)
        }

        if !left.isEmpty && right.isEmpty {
            print("  right is empty, not in right order\n")
            return .isInRightOrder(false)
        }

        var idx = 0
        while idx < left.count {
            if idx >= right.count {
                print("  right runs out, but left still counting, false\n")
                return .isInRightOrder(false)
            }

            let res = comparePacket(left: left[idx], right: right[idx])
            switch res {
            case .isEqual:
                idx += 1
            case .isInRightOrder(_):
                return res
            }
        }

        return idx == right.count ? .isEqual : .isInRightOrder(idx < right.count)
    }

    private func parseInput(_ input: String) -> [PacketPair] {
        let packetsPairs = input.split(separator: "\n\n")
        var ret = [PacketPair]()
        for pairs in packetsPairs {
            let packets = pairs.split(separator: "\n").map(String.init)
            guard packets.count == 2,
                  let (left, _) = parsePacket(packet: packets[0]),
                  let (right, _) = parsePacket(packet: packets[1])
            else { continue }
            ret.append(PacketPair(left: left, right: right))
        }
        return ret
    }

    private func parsePacket(packet: String) -> (Packet, Int)? {
        guard let startBracket = packet.first, startBracket == "[" else { return nil }

        var currentPacket = [Packet]()
        // Skip the start [
        var idx = packet.index(after: packet.startIndex)
        var consumedCount = 1

        while idx < packet.endIndex {
            if packet[idx] == "[" {
                if let (subPacket, consumed) = parsePacket(packet: String(packet[idx...])) {
                    currentPacket.append(subPacket)
                    consumedCount += consumed
                    idx = packet.index(idx, offsetBy: consumed)
                }
            } else if packet[idx].wholeNumberValue != nil {
                var numCount = 0
                var numStr = ""
                while packet[idx].isNumber {
                    numStr += String(packet[idx])
                    numCount += 1
                    idx = packet.index(after: idx)
                }
                currentPacket.append(.element(Int(numStr)!))
                consumedCount += numCount
            } else if packet[idx] == "]" {
                consumedCount += 1
                break
            } else {
                consumedCount += 1
                idx = packet.index(after: idx)
            }
        }

        return (Packet.sequence(currentPacket), consumedCount)
    }
}
