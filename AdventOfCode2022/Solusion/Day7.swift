import Foundation

struct File {
    let name: String
    let size: Int
}

final class Directory {
    var parent: Directory? = nil
    let name: String
    var size: Int = 0
    var files: [File] = []
    var childDirectories: [Directory] = []

    init(name: String) {
        self.name = name
    }
}

final class DirectoryTree {
    let root = Directory(name: "/")

    func constructTreeByParsingCommandLines(_ lines: [Substring]) {
        var current: Directory? = root
        var index = -1
        while index + 1 < lines.count {
            index += 1
            let line = lines[index]
            let parts = line.split(separator: " ")
            guard parts.count >= 2,
                  let prompt = parts.first,
                  prompt == "$"
            else { continue }

            switch parts[1] {
            case "cd":
                if let targetStr = parts.last {
                    let target = String(targetStr)
                    switch target {
                    case "/":
                        while let curr = current, let parent = curr.parent {
                            parent.size += curr.size
                            current = parent
                        }
                        current = root
                    case "..":
                        let tmp = current?.size
                        current = current?.parent
                        if let tmp {
                            current?.size += tmp
                        }
                    default:
                        let targetDir = Directory(name: target)
                        if let currentDir = current {
                            targetDir.parent = current
                            currentDir.childDirectories.append(targetDir)
                            current = targetDir
                        } else {
                            current = Directory(name: target)
                        }
                    }
                }
            case "ls":
                index += 1
                var lsLine = ""
                while index < lines.count {
                    lsLine = String(lines[index])
                    let parts = lsLine.split(separator: " ")
                    guard parts.count == 2 else { break }
                    if parts[0] == "dir" {
                        index += 1
                    } else if let size = Int(parts[0]) {
                        current?.size += size
                        index += 1
                    } else {
                        break
                    }
                }
                index -= 1
            default: continue
            }
        }
        if let currName = current?.name, currName != root.name {
            while let curr = current, let parent = curr.parent {
                parent.size += curr.size
                current = parent
            }
        }
    }

    func traverse(dir: Directory, action: (Directory) -> Void) {
        for childDir in dir.childDirectories {
            traverse(dir: childDir, action: action)
        }

        action(dir)
    }
}


struct Day7Resolver: Resolver {
    let day = Day(input: "day7")

    func resolve(input: String) {
        let lines = input.split(separator: "\n")

        let directoryTree = DirectoryTree()
        directoryTree.constructTreeByParsingCommandLines(lines)

        // Part 1
        print("Part1: ")
        var totalSizeBelow100_000 = 0
        directoryTree.traverse(dir: directoryTree.root) { dir in
            if dir.size < 100_000 {
                totalSizeBelow100_000 += dir.size
            }
        }
        print("total size of directories that have size below 100000: \(totalSizeBelow100_000)")

        // Part 2
        print("Part2: ")
        let volumeSize = 70_000_000
        let desiredFreeSpace = 30_000_000
        let freeSpace = volumeSize - directoryTree.root.size
        let targetSize = desiredFreeSpace - freeSpace
        print("root.size=\(directoryTree.root.size), freeSize=\(freeSpace), targetSize=\(targetSize)")
        var candidates = [Directory]()
        directoryTree.traverse(dir: directoryTree.root) { dir in
            if dir.size >= targetSize {
                candidates.append(dir)
            }
        }
        if let target = candidates.min(by: { lhs, rhs in lhs.size < rhs.size }) {
            print("target that should be deleted: [\(target.name), \(target.size)]")
        } else {
            print("could not find the proper directory to delete.")
        }
    }
}
