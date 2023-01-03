//
// Created on 2023/01/03, by Yin Tan
// 
//

import Foundation

enum InputReader {
    static func read(day: Day) -> String? {
        let fileName = day.input
        guard let filePath = Bundle.main.path(forResource: fileName, ofType: "txt") else {
            print("Failed finding file: \(fileName).txt")
            return nil
        }

        do {
            return try String(contentsOfFile: filePath)
        } catch {
            print("Failed reading file \(filePath)")
            return nil
        }
    }
}
