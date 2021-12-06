struct Line {
    let p0: (Int, Int)
    let p1: (Int, Int)
    let isFlat: Bool

    init(_ lineData: String) {
        let dots = lineData.components(separatedBy: " -> ").map { $0.split(separator: ",").map {Int($0)!}}
        (p0.0, p0.1) = (dots[0][0], dots[0][1])
        (p1.0, p1.1) = (dots[1][0], dots[1][1])
        isFlat = p0.0 == p1.0 || p0.1 == p1.1
    }
    
    var pointsFlat: [(Int, Int)] {
        get {
            if isFlat {
                if p0.0 == p1.0 {
                    return (min(p0.1,p1.1)...max(p0.1,p1.1)).map { (p0.0, $0) }
                } else {
                    return (min(p0.0,p1.0)...max(p0.0,p1.0)).map { ($0, p0.1) }
                }
            }
            return []
        }
    }
    var points: [(Int, Int)] {
        get {
            if isFlat {
                return pointsFlat
            }
            else {
                let d = Int((p1.0 - p0.0).magnitude)
                let dx = (p1.0 - p0.0).signum()
                let dy = (p1.1 - p0.1).signum()
                return (0...d).map { ((p0.0+(dx*$0), p0.1+(dy*$0))) }
            }
        }
    }
}
func lookupDangers(_ input: [String], _ looker: KeyPath<Line, [(Int, Int)]>) -> Int {
    var crosses = [Int: [Int: Int]]()
    input.map { Line($0) }          // Lines
        .map { $0[keyPath: looker] }// Array of points arrays
        .reduce([], +)              // Array of points
        .forEach { p in             // Filled `crosses`
            crosses[p.0, default: [:]][p.1, default: 0] += 1
        }
    return crosses.values.reduce(0) { $0 + $1.values.filter { $0 > 1 }.count }
}
class Task9: Task {
    func calc(_ inputFile: String) -> Int {
        lookupDangers(fileData(inputFile), \Line.pointsFlat)
    }
}

class Task10: Task {
    func calc(_ inputFile: String) -> Int {
        lookupDangers(fileData(inputFile), \Line.points)
    }
}
