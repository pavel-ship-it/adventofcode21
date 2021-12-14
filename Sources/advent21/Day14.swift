class Task27: Task {
    func calc(_ inputFile: String, _ depth: Int) -> Int {
        let data = fileData(inputFile)
        let sequence = [Character](data[0])
        var pairs = [[Character]: UInt64]()
        var chars = [Character: UInt64]()
        sequence.forEach {
            chars[$0, default:0] += 1
        }
        for i in 0..<sequence.count-1 {
            pairs[[sequence[i], sequence[i+1]], default: 0] += 1
        }
        let insertions = data.dropFirst().reduce([[Character]: Character]()) {
            let line = $1.components(separatedBy: " -> ")
            var out = $0
            out[Array(line[0])] = line[1].first!
            return out
        }
        for _ in 0..<depth {
            pairs = pairs.reduce([[Character]: UInt64]()) {
                var out = $0
                let newChar = insertions[$1.key]!
                out[[$1.key[0], newChar], default: 0] += $1.value
                out[[newChar, $1.key[1]], default: 0] += $1.value
                chars[newChar, default: 0] += $1.value
                return out
            }
        }
        return Int(chars.values.max()! - chars.values.min()!)
    }
    func calc(_ inputFile: String) -> Int {
        calc(inputFile, 10)
    }
}
class Task28: Task27 {
    override func calc(_ inputFile: String) -> Int {
        calc(inputFile, 40)
    }
}
