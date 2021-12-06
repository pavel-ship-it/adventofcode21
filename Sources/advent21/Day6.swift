class Task11: Task {
    func calc(_ inputFile: String) -> Int {
        var fishes = fileData(inputFile)[0].components(separatedBy: ",").map { Int($0)! }
            .reduce([Int](repeating: 0, count: 9)) {
                var ret = $0
                ret[$1] += 1
                return ret
            }
        (0..<80).forEach { _ in
            fishes[7] += fishes[0]
            fishes.append(fishes[0])
            fishes.remove(at: 0)
        }
        return fishes.reduce(0, +)
    }
}

class Task12: Task {
    func calc(_ inputFile: String) -> Int {
        var fishes = fileData(inputFile)[0].components(separatedBy: ",").map { UInt($0)! }
            .reduce([UInt](repeating: 0, count: 9)) {
                var ret = $0
                ret[Int(exactly: $1)!] += 1
                return ret
            }
        (0..<256).forEach { _ in
            fishes[7] += fishes[0]
            fishes.append(fishes[0])
            fishes.remove(at: 0)
        }
        return Int(fishes.reduce(0, +))
    }
}
