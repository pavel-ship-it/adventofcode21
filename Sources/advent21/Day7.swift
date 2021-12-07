import Foundation
class Task13: Task {
    func consumption(_ dist: Int) -> Int { dist }
    func buildConsumptionTable(_ max: Int) { }
    func calc(_ inputFile: String) -> Int {
        let croud = fileData(inputFile)[0].components(separatedBy: ",").map { Int($0)! }
        var min = Int.max
        var max = Int.min
        let alignment = croud.reduce([Int: Int]()) {
            var out = $0
            out[$1, default: 0] += 1
            if $1 < min {
                min = $1
            }
            if $1 > max {
                max = $1
            }
            return out
        }
        buildConsumptionTable(max)
        var minConsumption = Int.max
        (min...max).forEach { align in
            var ptCons = 0
            alignment.forEach {
                ptCons += consumption(Int((align - $0).magnitude)) * $1
            }
            if ptCons < minConsumption {
                minConsumption = ptCons
            }
        }
        return minConsumption
    }
}

class Task14: Task13 {
    var consT = [0]
    override func consumption(_ dist: Int) -> Int {
        return consT[dist]
    }
    override func buildConsumptionTable(_ max: Int) {
        (1...max).forEach { i in
            consT.append(i + consT[i-1])
        }
    }
}
