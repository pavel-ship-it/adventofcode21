class Task13: Task {
    func consumption(_ dist: Int) -> Int { dist }
    func calc(_ inputFile: String) -> Int {
        let croud = fileData(inputFile)[0].components(separatedBy: ",").map { Int($0)! }
        var posMin = Int.max
        var posMax = Int.min
        let alignment = croud.reduce([Int: Int]()) {
            var out = $0
            out[$1, default: 0] += 1
            posMin = min(posMin, $1)
            posMax = max(posMax, $1)
            return out
        }
        return (posMin...posMax).map { align in
            alignment.reduce(0) {
                $0 + consumption(Int((align - $1.0).magnitude)) * $1.1
            }
        }.min()!
    }
}
class Task14: Task13 {
    override func consumption(_ dist: Int) -> Int {
        return dist * (dist + 1) / 2
    }
}