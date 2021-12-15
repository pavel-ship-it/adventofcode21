class Task29: Task {
    var maxV = 0
    var field = [[Int]]()
    var costs = [[Int]]()
    func cost(_ p: Point) -> Int {
        if costs[p.y][p.x] != 0 {
            return costs[p.y][p.x]
        }
        if p.x >= maxV-1 , p.y >= maxV-1 {
            costs[p.y][p.x] = field[p.y][p.x]
            return costs[p.y][p.x]
        }
        var cX = Int.max
        var cY = Int.max
        if p.x < maxV-1 {
            let d = Point(x: p.x+1, y: p.y)
            cX = field[p.y][p.x] + cost(d)
        }
        if p.y < maxV-1 {
            let d = Point(x: p.x, y: p.y+1)
            cY = field[p.y][p.x] + cost(d)
        }
        costs[p.y][p.x] = min(cX, cY)
        return costs[p.y][p.x]
    }
    func loadMap(_ inputFile: String) {
        field = fileData(inputFile).map { $0.map { Int(String($0))! } }
        maxV = field.count
        field[0][0] = 0
        costs = [[Int]](repeating: [Int](repeating: 0, count: maxV), count: maxV)
    }
    func calc(_ inputFile: String) -> Int {
        loadMap(inputFile)
        _ = cost(Point(x: 0, y: 0))
        return costs[0][0]
    }
}

class Task30: Task29 {
    override func calc(_ inputFile: String) -> Int {
        loadMap(inputFile)
        while nextVisit.count > 0 {
            let pt = nextVisit.remove(at: 0)
            if isVisited[pt.y][pt.x] {
                continue
            }
            _ = cost(pt)
        }
        return costs[maxV-1][maxV-1]
    }
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
        maxV = field.count
        costs = [[Int]](repeating: [Int](repeating: Int.max, count: maxV), count: maxV)
        isVisited = [[Bool]](repeating: [Bool](repeating: false, count: maxV), count: maxV)
        field[0][0] = 0
        costs[0][0] = 0
    }
    var nextVisit: [Point] = [Point(x: 0, y: 0)]
    var isVisited = [[Bool]]()
    func compare(_ a: Point, _ b: Point) {
        if costs[a.y][a.x] > costs[b.y][b.x]+field[a.y][a.x] {
            costs[a.y][a.x] = costs[b.y][b.x]+field[a.y][a.x]
            isVisited[a.y][a.x] = false
            nextVisit.append(a)
        }

    }
    override func cost(_ p: Point) -> Int {
        if p.x > 0 {
            let d = Point(x: p.x-1, y: p.y)
            compare(d, p)
//            if !isVisited[d.y][d.x] {
//                costs[d.y][d.x] = min(costs[d.y][d.x], costs[p.y][p.x]+field[d.y][d.x])
//                nextVisit.append(d)
//            }
        }
        if p.y > 0 {
            let d = Point(x: p.x, y: p.y-1)
            compare(d, p)
//            if !isVisited[d.y][d.x] {
//                costs[d.y][d.x] = min(costs[d.y][d.x], costs[p.y][p.x]+field[d.y][d.x])
//                nextVisit.append(d)
//            }
        }
        if p.x < maxV-1 {
            let d = Point(x: p.x+1, y: p.y)
            compare(d, p)
//            if !isVisited[d.y][d.x] {
//                costs[d.y][d.x] = min(costs[d.y][d.x], costs[p.y][p.x]+field[d.y][d.x])
//                nextVisit.append(d)
//            }
        }
        if p.y < maxV-1 {
            let d = Point(x: p.x, y: p.y+1)
            compare(d, p)
//            if !isVisited[d.y][d.x] {
//                costs[d.y][d.x] = min(costs[d.y][d.x], costs[p.y][p.x]+field[d.y][d.x])
//                nextVisit.append(d)
//            }
        }
        isVisited[p.y][p.x] = true
        return costs[p.y][p.x]
    }
}
