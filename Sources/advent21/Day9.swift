struct Point: Hashable {
    let x: Int
    let y: Int
    init (_ x: Int, _ y: Int) {
        self.x = x
        self.y = y
    }
}
class Task17: Task {
    func isLow(_ hMap: [[Int]], _ y: Int, _ x: Int, _ w: Int, _ h: Int) -> Bool {
        if hMap[y][x] == 9 {
            return false
        }
        for (u, v) in [(x-1, y), (x+1, y), (x, y-1), (x, y+1)] {
            if v < 0 || v >= h || u < 0 || u >= w {
                continue
            }
            if (hMap[y][x] >= hMap[v][u]) {
                return false
            }
        }
        return true
    }
    func lowLands(_ hMap: [[Int]], _ w: Int, _ h: Int) -> [Point] {
        var lows = [Point]()
        for y in (0..<h) {
            for x in (0..<w) {
                if isLow(hMap, y, x, w, h) {
                    lows.append(Point(x, y))
                }
            }
        }
        return lows
    }
    func calc(_ inputFile: String) -> Int {
        let hMap = fileData(inputFile).map { $0.map { Int(String($0))! } }
        return lowLands(hMap, hMap[0].count, hMap.count).reduce(into: 0) { $0 += hMap[$1.y][$1.x] + 1 }
    }
}
class Task18: Task17 {
    func flood(_ low: Point, _ filled: Set<Point>, _ hMap: [[Int]], _ w: Int, _ h: Int) -> Set<Point> {
        var bassin: Set<Point> = filled
        for (u, v) in [(low.x-1, low.y), (low.x+1, low.y), (low.x, low.y-1), (low.x, low.y+1)] {
            if v < 0 || v >= h || u < 0 || u >= w {
                continue
            }
            if hMap[v][u] == 9 {
                continue
            }
            let (inserted, _) = bassin.insert(Point(u, v))
            if !inserted {
                continue
            }
            bassin = bassin.union(flood(Point(u, v), bassin, hMap, w, h))
        }
        return bassin
    }
    override func calc(_ inputFile: String) -> Int {
        let hMap = fileData(inputFile).map { $0.map { Int(String($0))! } }
        let w = hMap[0].count
        let h = hMap.count
        let lows = lowLands(hMap, w, h)
        let bassins = lows.map { flood($0, [$0], hMap, w, h) }.sorted { $0.count > $1.count }
        return bassins[0].count * bassins[1].count * bassins[2].count
    }
}
