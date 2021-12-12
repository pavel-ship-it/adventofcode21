class Task23: Task {
    func buildMap(_ input: [String]) -> [String: Set<String>] {
        input.reduce([String: Set<String>]()) {
            var cave = $0
            let path = $1.split(separator: "-")
            if String(path[1]) != "start" {
                cave[String(path[0]), default: []].insert(String(path[1]))
            }
            if String(path[0]) != "start" {
                cave[String(path[1]), default: []].insert(String(path[0]))
            }
            return cave
        }
    }
    func nextStep(_ walk: [String], _ cave: [String: Set<String>], _ walks: [[String]]) -> [[String]] {
        var newWalks = [[String]]()
        cave[walk.last!]!.forEach { s in
            if s == "end" {
                var finish = walk
                finish.append(s)
                newWalks.append(finish)
                return
            } else if s.lowercased() == s && walk.contains(s) {
                return
            }
            var walkNext = walk
            walkNext.append(s)
            newWalks += nextStep(walkNext, cave, walks)
        }
        return walks + newWalks
    }
    func calc(_ inputFile: String) -> Int {
        let cave = buildMap(fileData(inputFile))
        return nextStep(["start"], cave, [[String]]()).count
    }
}
class Task24: Task23 {
    override func nextStep(_ walk: [String], _ cave: [String: Set<String>], _ walks: [[String]]) -> [[String]] {
        var newWalks = [[String]]()
        cave[walk.last!]!.forEach { s in
            if s == "end" {
                var finish = walk
                finish.append(s)
                newWalks.append(finish)
                return
            }
            if s.lowercased() == s && walk.contains(s) && walk.reduce([String: Int](), {
                var out = $0
                if $1.lowercased() == $1 {
                    out[$1, default: 0] += 1
                }
                return out
            }).values.first(where: { $0 >= 2 }) != nil {
                // walk contains s and there are no other small visited twice
                return
            }
            var walkNext = walk
            walkNext.append(s)
            newWalks += nextStep(walkNext, cave, walks)
        }
        return walks + newWalks
    }
}
