enum Fold {
    case horisontal(Int)
    case vertical(Int)
}
extension Point {
    func reflect(_  mirror: Fold) -> Point {
        var out: Point
        switch mirror {
        case .horisontal(let mirror):
            if mirror < y {
                out = Point(x: x, y: mirror * 2 - y)
            } else {
                out = self
            }
        case .vertical(let mirror):
            if mirror < x {
                out = Point(x: mirror * 2 - x, y: y)
            } else {
                out = self
            }
        }
        return out
    }
}
class Task25: Task {
    func load(_ inputFile: String) -> (Set<Point>, [Fold]) {
        var points = Set<Point>()
        var folds = [Fold]()
        fileData(inputFile).forEach { line in
            if line.first! == "f" {
                let vals = String(line.dropFirst(11)).split(separator: "=")
                if vals[0] == "x" {
                    folds.append(.vertical(Int(vals[1])!))
                } else {
                    folds.append(.horisontal(Int(vals[1])!))
                }
            } else {
                let vals = line.split(separator: ",")
                points.insert(Point(x: Int(vals[0])!, y: Int(vals[1])!))
            }
        }
        return (points, folds)
    }
    func fold(_ fold: Fold, _ points: Set<Point>) -> Set<Point> {
        points.reduce(into: Set<Point>()) {
            let p = $1.reflect(fold)
            $0.insert(p)
        }
    }
    func calc(_ inputFile: String) -> Int {
        var (points, folds) = load(inputFile)
        points = fold(folds[0], points)
        return points.count
    }
}
class Task26: Task25 {
    override func calc(_ inputFile: String) -> Int {
        var (points, folds) = load(inputFile)
        folds.forEach { f in
            points = fold(f, points)
        }
        let (mx, my) = points.reduce(into: (0, 0)) { partialResult, pt in
            partialResult = (max(partialResult.0, pt.x), max(partialResult.1, pt.y))
        }
        var display = [[String]](repeating: [String](repeating: " ", count: mx+1), count: my+1)
        points.forEach { pt in
            display[pt.y][pt.x] = "*"
        }
        print(display.map { $0.joined(separator: "") }.joined(separator: "\n"))
        return points.count
    }
}
