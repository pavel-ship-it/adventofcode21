struct Point: Hashable {
    let x: Int
    let y: Int
}
class Task17: Task {
    func isLow(_ hMap: [[Int]], _ y: Int, _ x: Int) -> Bool {
        if hMap[y][x] == 9 {
            return false
        }
        for (u, v) in [(x-1, y), (x+1, y), (x, y-1), (x, y+1)] {
            if v < 0 || v >= hMap.count || u < 0 || u >= hMap[0].count {
                continue
            }
            if (hMap[y][x] >= hMap[v][u]) {
                return false
            }
        }
        return true
    }
    func lowLands(_ hMap: [[Int]]) -> [Point] {
        var lows = [Point]()
        for y in (0..<hMap.count) {
            for x in (0..<hMap[0].count) {
                if isLow(hMap, y, x) {
                    lows.append(Point(x: x, y: y))
                }
            }
        }
        return lows
    }
    func calc(_ inputFile: String) -> Int {
        let hMap = fileData(inputFile).map { $0.map { Int(String($0))! } }
        return lowLands(hMap).reduce(into: 0) { $0 += hMap[$1.y][$1.x] + 1 }
    }
}
class Task18: Task17 {
    func flood(_ low: Point, _ filled: Set<Point>, _ hMap: [[Int]]) -> Set<Point> {
        var bassin: Set<Point> = filled
        for (u, v) in [(low.x-1, low.y), (low.x+1, low.y), (low.x, low.y-1), (low.x, low.y+1)] {
            if v < 0 || v >= hMap.count || u < 0 || u >= hMap[0].count {
                continue
            }
            if hMap[v][u] == 9 {
                continue
            }
            let (inserted, _) = bassin.insert(Point(x: u, y: v))
            if !inserted {
                continue
            }
            bassin = bassin.union(flood(Point(x: u, y: v), bassin, hMap))
        }
        return bassin
    }
    override func calc(_ inputFile: String) -> Int {
        let hMap = fileData(inputFile).map { $0.map { Int(String($0))! } }
        let bassins = lowLands(hMap).map { flood($0, [$0], hMap) }.sorted { $0.count > $1.count }
        return bassins[0].count * bassins[1].count * bassins[2].count
    }
}
