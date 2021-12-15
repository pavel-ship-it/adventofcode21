class Task29: Task {
    var maxV = 0
    var field = [[Int]]()
    var costs = [[Int]]()
    var nextVisit: [Point] = [Point(x: 0, y: 0)]
    var isVisited = [[Bool]]()
    func calc(_ inputFile: String) -> Int {
        loadMap(inputFile)
        maxV = field.count
        costs = [[Int]](repeating: [Int](repeating: Int.max, count: maxV), count: maxV)
        isVisited = [[Bool]](repeating: [Bool](repeating: false, count: maxV), count: maxV)
        field[0][0] = 0
        costs[0][0] = 0
        while nextVisit.count > 0 {
            let pt = nextVisit.remove(at: 0)
            if isVisited[pt.y][pt.x] {
                continue
            }
            _ = cost(pt)
        }
        return costs[maxV-1][maxV-1]
    }
    func compare(_ a: Point, _ b: Point) {
        if costs[a.y][a.x] > costs[b.y][b.x]+field[a.y][a.x] {
            costs[a.y][a.x] = costs[b.y][b.x]+field[a.y][a.x]
            isVisited[a.y][a.x] = false
            nextVisit.append(a)
        }
    }
    func cost(_ p: Point) -> Int {
        if p.x > 0 {
            compare(Point(x: p.x-1, y: p.y), p)
        }
        if p.y > 0 {
            compare(Point(x: p.x, y: p.y-1), p)
        }
        if p.x < maxV-1 {
            compare(Point(x: p.x+1, y: p.y), p)
        }
        if p.y < maxV-1 {
            compare(Point(x: p.x, y: p.y+1), p)
        }
        isVisited[p.y][p.x] = true
        return costs[p.y][p.x]
    }

    func loadMap(_ inputFile: String) {
        field = fileData(inputFile).map { $0.map { Int(String($0))! } }
    }
}
class Task30: Task29 {
    override func loadMap(_ inputFile: String) {
        let tmpField = fileData(inputFile).map { $0.map { Int(String($0))! } }
        let len = tmpField.count
        field = [[Int]](repeating: [Int](repeating: 0, count: len*5), count: len*5)
        for v in (0..<5).reversed() {
            for u in (0..<5).reversed() {
                for y in (0..<len).reversed() {
                    for x in (0..<len).reversed() {
                        var val = tmpField[y][x] + (v+u)
                        while val > 9 {
                            val-=9
                        }
                        field[v*len+y][u*len+x] = val
                    }
                }
            }
        }
    }
}
