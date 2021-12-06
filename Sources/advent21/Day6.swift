func getFishes(_ input: String) -> [UInt] {
    input.components(separatedBy: ",").map { Int($0)! }
        .reduce([UInt](repeating: 0, count: 9)) {
            var ret = $0
            ret[$1] += 1
            return ret
        }
}
func grow(_ turns: Int, _ fishes: [UInt]) -> Int {
    var fishes = fishes
    (0..<turns).forEach { _ in
        fishes[7] += fishes[0]
        fishes.append(fishes[0])
        fishes.remove(at: 0)
    }
    return Int(exactly: fishes.reduce(0, +))!
}
class Task11: Task {
    func calc(_ inputFile: String) -> Int {
        let fishes = getFishes(fileData(inputFile)[0])
        return grow(80, fishes)
    }
}

class Task12: Task {
    func calc(_ inputFile: String) -> Int {
        let fishes = getFishes(fileData(inputFile)[0])
        return grow(256, fishes)
    }
}
