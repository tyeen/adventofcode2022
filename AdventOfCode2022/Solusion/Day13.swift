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
        pairs.forEach {
            print($0)
        }
    }

    private func parseInput(_ input: String) -> [PacketPair] {
        let packetsPairs = input.split(separator: "\n\n")
        var ret = [PacketPair]()
        for pairs in packetsPairs {
            let packets = pairs.split(separator: "\n").map(String.init)
            print("parse pairs: \(packets)")
            guard packets.count == 2,
                  let left = parsePacket(packet: packets[0]),
                  let right = parsePacket(packet: packets[1])
            else { continue }
            ret.append(PacketPair(left: left, right: right))
        }
        return ret
    }

    private func parsePacket(packet: String) -> Packet? {
        let stripped = packet.dropFirst().dropLast()
        var currentPacket = [Packet]()
        let parts = stripped.split(separator: ",")
        print("start parse packet: \(stripped)")
        for part in parts {
            print("parse packet part: \(part)")
            if part.starts(with: "["), let innerPacket = parsePacket(packet: String(part)) {
                currentPacket.append(innerPacket)
            } else if let num = Int(part) {
                currentPacket.append(.element(num))
            }
        }
        print("end parse packet: \(stripped)")
        print("")
        return Packet.sequence(currentPacket)
    }

    private func parseElement(element: String) -> Int? {
//        var ret = 0
//        for (idx, ch) in element.enumerated() {
//            if let n = ch.wholeNumberValue {
//                ret += n * pow(10, idx)
//            } else {
//                return nil
//            }
//        }
//        return ret
        Int(element)
    }
}
